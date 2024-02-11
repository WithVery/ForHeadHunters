unit UpdateThread;

{$I DEFINES.INC}

interface

uses
  VirtualTrees,
  ZConnection,
{$IFDEF THREADSDBGOUTPUT}
  Forms,
  Dialogs,
{$ENDIF}
  windows, // for OutputDebugString
  SysUtils,  // for Exception
  StrUtils,  // for LeftStr
	ZDbcIntfs, // for EZDBCException
  SyncObjs,  // for wrSignaled

  ZDataset,
  GlobalVars,
  Classes;

type
  TUpdateThread = class(TThread)
  public
  	UTOrgsNodesArr		: TAPVN; //array of PVirtualNode;
  	UTAssetNodesArr		: TAPVN; //array of PVirtualNode;
  	UTBankNodesArr		: TAPVN; //array of PVirtualNode;
    UTFundNodesArr		: TAPVN; //array of PVirtualNode;

    UTConnection	: TZConnection;
    UTMainTree		: TVirtualStringTree;
    ExitNow				: boolean;

  private
    { Private declarations }
    UTCurNode			: PVirtualNode;
    UTCurNodeData	: PVTResourceData;
    UTValue				: extended;
    UTLConnection	: TZConnection;
	  LDataset	: TZQuery;

    ULHost : string;
    ULUser : string;
    ULPort : integer;
    ULPwd  : string;
    ULDb   : string;
    ULProt : string;

  protected
    procedure Execute; override;
    procedure UpdateNodeValue;
    function ExitIt: boolean;
  end;

implementation

{ TUpdateThread }

function TUpdateThread.ExitIt: boolean;
begin
//{$IFDEF THREADSDBGOUTPUT}
//  OutputDebugString('---- Exit signal check ----');
//{$ENDIF}
//  UpdateCS.Enter;
//  Result := ExitNow;
//  UpdateCS.Leave;
  Result := Terminated;
  if Result then begin
{$IFDEF THREADSDBGOUTPUT}
    OutputDebugString('---- Update thread - Exit Signal caught!!!');
{$ENDIF}
  end;
end;

procedure TUpdateThread.Execute;

	procedure LoadArchedFunds;
    // pulling proper data procedure
	  procedure LoadArchedEntity(alink : string; aprefix: string);
    var
	    Pflink			 : ^string;
			ArchFundData : PVTResourceData;
    begin
	  	LDataset.SQL.Text  := 'SELECT`name`,`link`,`sub`,`page`,`assetlink`,`arched`FROM ' + alink + ' LEFT JOIN ' + aprefix + 'fundsvsassets ON link=fundlink WHERE arched=1';
			LDataset.Open;
  		while not LDataset.Eof do begin
	    	new(Pflink);
		    if Pflink = nil then exit;
  		  Pflink^ := alink;

	  	  new(ArchFundData);

  	  	ArchFundData.name    := LDataset.FieldByName('name').AsString;
	    	ArchFundData.link    := LDataset.FieldByName('link').AsString;
		    ArchFundData.sub     := LDataset.FieldByName('sub').AsInteger;
  		  ArchFundData.balance := 0; // supposed to be 0 if the fund is in the archive
		    ArchFundData.index	 := 0; // LDataset.FieldByName('index').AsInteger; // not needed
  		  ArchFundData.page		 := LDataset.FieldByName('page').AsInteger;
				ArchFundData.prefix  := aprefix;
				ArchFundData.arched	 := LDataset.FieldByName('arched').AsInteger = 1;
	  	 	ArchFundData.alink   := LDataset.FieldByName('assetlink').AsString;
  	  	ArchFundData.branch	 := BRANCH_FUNDS;

	  	  PostMessage(MFPF.Handle, UM_ARCHFUNDTOBEADDED, integer(Pflink), integer(ArchFundData));
      	Outputdebugstring(PWideChar('Info about ' + ArchFundData.link + ' sent'));
	  	  LDataset.Next;
		  end;
    end;
  var
    LFLink	 : string;
    LPrefix  : string;
    i				 : integer;
	  NodeData : PVTResourceData;
  begin
  	LoadArchCS.Enter;
    LFLink	:= LoadArchFLink;
    LoadArchFLink := '';
    LPrefix := LoadArchPrefix;
    LoadArchPrefix := '';
  	LoadArchCS.Leave;
    if LFLink = '' then begin
      exit;
    end;

	  LDataset.SQL.Text := 'SET CHARSET cp1251';
	  LDataset.ExecSQL;

    // first we pull the data for the org where the request was initiated
		LoadArchedEntity(LFlink, LPrefix);

    // second we do the same for other orgs
		for i := Low(UTFundNodesArr) to High(UTFundNodesArr) do begin
	    if UTFundNodesArr[i] = nil then continue;

      NodeData := UTMainTree.GetNodeData(UTFundNodesArr[i]);
    	if (NodeData.link <> '') and (LFLink <> NodeData.link) then begin
				LoadArchedEntity(NodeData.link, NodeData.prefix);
      end;
    end;
  end;

	procedure UpdateFunds(ANode: PVirtualNode);
  var
  	Node			: PVirtualNode;
	  NodeData	: PVTResourceData;
    ANodeData	: PVTResourceData;
    LRDataset	: TZQuery;
  begin

  	if ANode = nil then
    	Exit;

    ANodeData	:= UTMainTree.GetNodeData(ANode);
  	LRDataset	:= TZQuery.Create(nil);
    LRDataset.Connection	:= UTLConnection;
    Node 			:= UTMainTree.GetFirstChild(ANode);

    while (not Terminated) and (not ExitIt) and Assigned(UTLConnection) and (Node <> nil) do begin
      NodeData	:= UTMainTree.GetNodeData(Node);
	    try
  	    LRDataset.SQL.Text := 'SELECT`balance`FROM`' + ANodeData.link + '`WHERE`link`=:fLink';
    	  LRDataset.ParamByName('fLink').AsString	:= NodeData.link;
      	LRDataset.Open;

	      if LRDataset.RecordCount > 0 then
  				UTValue := LRDataset.FieldByName('balance').AsFloat
    	  else
    			UTValue := 0;
	    except
			  LRDataset.Free;
    	  Exit;
	    end;
	    UTCurNode	:= Node;

	    Synchronize(UpdateNodeValue);
			if (not ExitIt) and (NodeData.page = 8) then begin
      	UpdateFunds(Node);
      end;

    	Node := UTMainTree.GetNextSibling(Node);
    end; // while

		LRDataset.Free;
  end;

{$IFDEF TLOG}
	procedure LoadLogEvents;
  var
    i				 : integer;
    iorg : integer;
    sdata : string;
    pdata : ^string;
	begin
	  LDataset.SQL.Text  := 'SELECT`id`,`sdt`,`data`FROM`log`WHERE`code`=:acode AND`type`=:atype AND`sdt`>:adate ORDER BY`sdt`';
    LDataset.ParamByName('acode').AsInteger  := LC_FPAPPRVD;
    LDataset.ParamByName('atype').AsInteger  := LT_BC;
    LDataset.ParamByName('adate').AsDateTime := GLogPulledDT;

    try
			LDataset.Open;
    except
      exit;
    end;
  	while not LDataset.Eof do begin
	    try
	      sdata := LDataset.FieldByName('data').AsString;
    	except
	      exit;
  	  end;
		  i := Pos(':', sdata);
//      Outputdebugstring(PWideChar('Pos(`:`, sdata) = ' + IntToStr(i)));
		  if(i = 0) then Exit;

  		iorg := StrToInt(LeftStr(sdata, i - 1));
			sdata:= MidStr(sdata, i + 1, Length(sdata));

      New(pdata);
      pdata^ := sdata;

			PostMessage(MFPF.Handle, UM_FPAPPROVEDEXT, iorg, integer(pdata));
    	GLogPulledDT := LDataset.FieldByName('sdt').AsDateTime;
      Outputdebugstring(PWideChar('Info about ' + sdata + ' sent'));
	    try
		  	LDataset.Next;
    	except
	      exit;
  	  end;
    end;
      Outputdebugstring(PWideChar('GLogPulledDT after: ' + DateToStr(GLogPulledDT)));
  end;
{$ENDIF}

var
	Node 			: PVirtualNode;
  NodeData	: PVTResourceData;
  i         : integer;
  RCNeeded  : boolean;
{$IFDEF FAFH}
  bIsFndr   : boolean;
  slPrefix  : string;
{$ENDIF}

begin
  { Place thread code here }
  UpdateCS.Enter;
  ExitNow := false;
  UpdateCS.Leave;

  RCNeeded := false;


{$IFDEF THREADSDBGOUTPUT}
  OutputDebugString(PWideChar('---- Update thread (' + IntToStr(GetCurrentThreadId) + ') started ---'));
{$ENDIF}
	UTLConnection := TZConnection.Create(nil);

  UTLConnection.HostName	:= UTConnection.HostName;
  UTLConnection.User			:= UTConnection.User;
  UTLConnection.Port			:= UTConnection.Port;
  UTLConnection.Password	:= UTConnection.Password;
  UTLConnection.Database 	:= UTConnection.Database;
  UTLConnection.Protocol	:= UTConnection.Protocol;

  UTConnection := nil;

  ULHost := UTLConnection.HostName;
  ULUser := UTLConnection.User;
  ULPort := UTLConnection.Port;
  ULPwd  := UTLConnection.Password;
  ULDb   := UTLConnection.Database;
  ULProt := UTLConnection.Protocol;

  UTLConnection.ClientCodepage := rsCharsetSetUp;
  SetUpEncryption(UTLConnection);

  try
  	UTLConnection.Connect;
  except
  	on e:Exception do begin
    	UTLConnection.Free;
	    Exit;
    end;
  end;

  LDataset := TZQuery.Create(nil);
  LDataset.Connection	:= UTLConnection;
  while (not ExitIt) and (not Terminated) do begin

    if not Assigned(UTLConnection) then begin
    	UTLConnection := TZConnection.Create(nil);

      UTLConnection.HostName := ULHost;
      UTLConnection.User		 := ULUser;
      UTLConnection.Port		 := ULPort;
      UTLConnection.Password := ULPwd;
      UTLConnection.Database := ULDb;
      UTLConnection.Protocol := ULProt;

      UTLConnection.ClientCodepage := rsCharsetSetUp;
      SetUpEncryption(UTLConnection);

      try
  	    UTLConnection.Connect;
      except
  	    on e:Exception do begin
        	UTLConnection.Free;
          Continue;
        end;
      end;
    end;

    if Assigned(UTLConnection) and ((not UTLConnection.Connected) or RCNeeded) then begin
{$IFDEF THREADSDBGOUTPUT}
      OutputDebugString('=== Reconnecting Update thread''s connection ... ===');
{$ENDIF}
      try
		    SetUpEncryption(UTLConnection);
        UTLConnection.Reconnect
      except
  	    on e:Exception do begin
          Continue;
        end;
      end;
    end;

    RCNeeded := false;

    if not Assigned(LDataset) then begin
      LDataset := TZQuery.Create(nil);
      LDataset.Connection	:= UTLConnection;
    end;

		if LoadArchEvent.WaitFor(200) = wrSignaled then begin
      OutputDebugString('=== LoadArchEvent signalled ... ===');
			LoadArchedFunds;
    end;

{$IFDEF TLOG}
		if LoadLogEvent.WaitFor(200) = wrSignaled then begin
      //OutputDebugString('=== LoadLogEvent signalled ... ===');

      // here goes pulling data from log table
			LoadLogEvents;

		  PostMessage(MFPF.Handle, UM_LOGPULLFINISHED, 0, 0);
    end;
{$ENDIF}


		if UpdateEvent.WaitFor(200) <> wrSignaled then begin
    	continue;
    end;
{$IFDEF THREADSDBGOUTPUT}
	  OutputDebugString('---- UpdateEvent processing ---');
{$ENDIF}

    if ExitIt then continue;

    if not UTLConnection.Connected then continue;

  	for i := Low(UTAssetNodesArr) to High(UTAssetNodesArr) do begin
    	if (UTAssetNodesArr[i] = nil) or (UTOrgsNodesArr[i] = nil) then
      	continue;
	    if (not ExitIt) and (not Terminated) then begin
{$IFDEF FAFH}
      	// check Founder feature
    	  NodeData := UTMainTree.GetNodeData(UTOrgsNodesArr[i]);
				bIsFndr := PrivPresentMO(NodeData.descr, 'b0');
        slPrefix := NodeData.prefix;
{$ENDIF}
				// Pulling root asset data
    	  NodeData := UTMainTree.GetNodeData(UTAssetNodesArr[i]);
      	if NodeData = nil then continue;

{$IFDEF FAFH}
			  if bIsFndr then begin
{$ENDIF}
	  			LDataset.SQL.Text := 'SELECT SUM(`balance`)AS`balance`FROM`' + NodeData.link + '`';
{$IFDEF FAFH}
				end
			  else begin
				  if (NodeData.link = slPrefix + 'asset') then begin
		  			LDataset.SQL.Text    := 'SELECT SUM(balance) AS`balance`FROM(SELECT`balance`FROM`' + slPrefix + 'bank`WHERE`fnd`=0 UNION SELECT`balance`FROM`' + slPrefix + 'asset`WHERE`index`<4)AS T1';
					end
				  else begin
					  LDataset.SQL.Text    := 'SELECT SUM(`balance`)as`balance`FROM`' + NodeData.link + '`WHERE fnd=0';
				  end;
			  end;
{$ENDIF}

{$IFDEF THREADSDBGOUTPUT}
  	    OutputDebugString(PWideChar(LDataset.SQL.Text));
{$ENDIF}
			  try
				  LDataset.Open;
  				if LDataset.RecordCount > 0 then
  					UTValue := LDataset.FieldByName('balance').AsFloat
			  	else
  					UTValue	:= 0;
				except
  	   	  on e: EZSQLException do begin
{$IFDEF THREADSDBGOUTPUT}
            OutputDebugString(PWideChar(IntToStr(e.ErrorCode) + ': ' + e.StatusCode + ' ' + e.Message));
{$ENDIF}
            RCNeeded := (e.ErrorCode = 1053) or (e.ErrorCode = 2006);
          	break;
		    	end;
  			end; // try
    	end; // if (not ExitIt) and (not Terminated) then begin

    	if (not ExitIt) and (not Terminated) then begin
		  	UTCurNode := UTAssetNodesArr[i];
  			Synchronize(UpdateNodeValue);

  			Node 		 	:= UTMainTree.GetFirstChild(UTAssetNodesArr[i]);

		  	// updating cash data
	  		NodeData 	:= UTMainTree.GetNodeData(Node);
				try
		  		LDataset.SQL.Text := 'SELECT`balance`FROM`' + NodeData.link + '`ORDER BY`index`DESC LIMIT 1';
{$IFDEF THREADSDBGOUTPUT}
      		OutputDebugString(PWideChar(LDataset.SQL.Text));
{$ENDIF}
	  			LDataset.Open;
		  		if LDataset.RecordCount > 0 then
  					UTValue := LDataset.FieldByName('balance').AsFloat
			  	else
  					UTValue := 0;
				except
       	  on e: EZSQLException do begin
{$IFDEF THREADSDBGOUTPUT}
            OutputDebugString(PWideChar(IntToStr(e.ErrorCode) + ': ' + e.StatusCode + ' ' + e.Message));
{$ENDIF}
            RCNeeded := (e.ErrorCode = 1053) or (e.ErrorCode = 2006);
          	break;
		    	end;
  			end; // try
      	if (not ExitIt) and (not Terminated) then begin
	  	  	UTCurNode := Node;
	  	  	Synchronize(UpdateNodeValue);
  	    end;

		  	// updating disb cash data
      	if (not Terminated) then begin
  		  	Node 		 	:= UTMainTree.GetNextSibling(Node);
	  	  	NodeData 	:= UTMainTree.GetNodeData(Node);
		  		try
			    	LDataset.SQL.Text := 'SELECT`balance`FROM`' + NodeData.link + '`ORDER BY`index`DESC LIMIT 1';
{$IFDEF THREADSDBGOUTPUT}
      			OutputDebugString(PWideChar(LDataset.SQL.Text));
{$ENDIF}
		  	  	LDataset.Open;
			  	  if LDataset.RecordCount > 0 then
  					  UTValue := LDataset.FieldByName('balance').AsFloat
  				  else
    					UTValue := 0;
          	// update it!
		        UTCurNode	:= Node;
  				  Synchronize(UpdateNodeValue);
			  	except
      	 	  on e: EZSQLException do begin
{$IFDEF THREADSDBGOUTPUT}
        	    OutputDebugString(PWideChar(IntToStr(e.ErrorCode) + ': ' + e.StatusCode + ' ' + e.Message));
{$ENDIF}
          	  RCNeeded := (e.ErrorCode = 1053) or (e.ErrorCode = 2006);
		          break;
  			    end;
    			end; // try
	      end; // if not terminated
  	  end; // if not terminated
    	if (not ExitIt) and (not Terminated) then begin
		  	UTCurNode := Node;
	  		Synchronize(UpdateNodeValue);
  	  end;
	  end; // for i: = Low(UTAssetNodesArr) to ...

		// bank data update
	  for i := Low(UTBankNodesArr) to High(UTBankNodesArr) do begin
  	  if (UTBankNodesArr[i] = nil) or (UTOrgsNodesArr[i] = nil) then
    	  continue;
	    if (not ExitIt) and (not Terminated) then begin
{$IFDEF FAFH}
      	// check Founder feature
    	  NodeData := UTMainTree.GetNodeData(UTOrgsNodesArr[i]);
				bIsFndr := PrivPresentMO(NodeData.descr, 'b0');
{$ENDIF}
				// Pulling root bank data
    	  NodeData := UTMainTree.GetNodeData(UTBankNodesArr[i]);
		  	LDataset.SQL.Text := 'SELECT SUM(`balance`)AS`balance`FROM`' + NodeData.link + '`';
{$IFDEF FAFH}
		  	LDataset.SQL.Text := LDataset.SQL.Text + 'WHERE`fnd`<=' + IntToStr(integer(bIsFndr));
{$ENDIF}

{$IFDEF THREADSDBGOUTPUT}
	      OutputDebugString(PWideChar(LDataset.SQL.Text));
{$ENDIF}
		    try
	  			LDataset.Open;
				  if LDataset.RecordCount > 0 then
  					UTValue := LDataset.FieldByName('balance').AsFloat
			  	else
  					UTValue := 0;
    	    UTCurNode	:= UTBankNodesArr[i];
  			  Synchronize(UpdateNodeValue);
	  	  except
  	   	  on e: EZSQLException do begin
{$IFDEF THREADSDBGOUTPUT}
            OutputDebugString(PWideChar(IntToStr(e.ErrorCode) + ': ' + e.StatusCode + ' ' + e.Message));
{$ENDIF}
            RCNeeded := (e.ErrorCode = 1053) or (e.ErrorCode = 2006);
    	      break;
  	  	  end;
		    end;
  	  end; // if not terminated

	    if (not ExitIt) and (not Terminated) then begin
			  // updating bank data
  			Node 		 	:= UTMainTree.GetFirstChild(UTBankNodesArr[i]);
	  		while (Node <> nil) and (not Terminated) do begin
			  	NodeData 	:= UTMainTree.GetNodeData(Node);
		  		LDataset.SQL.Text := 'SELECT`balance`FROM`' + NodeData.link + '`ORDER BY`index`DESC LIMIT 1';
{$IFDEF THREADSDBGOUTPUT}
    		  OutputDebugString(PWideChar(LDataset.SQL.Text));
{$ENDIF}
					try
				  	LDataset.Open;
	  				if LDataset.RecordCount > 0 then
  						UTValue := LDataset.FieldByName('balance').AsFloat
					  else
  						UTValue	:= 0;

		    		UTCurNode	:= Node;
			    	Synchronize(UpdateNodeValue);
	  	  	except
      	 	  on e: EZSQLException do begin
{$IFDEF THREADSDBGOUTPUT}
        	    OutputDebugString(PWideChar(IntToStr(e.ErrorCode) + ': ' + e.StatusCode + ' ' + e.Message));
{$ENDIF}
          	  RCNeeded := (e.ErrorCode = 1053) or (e.ErrorCode = 2006);
		          break;
    	    	end;
	  		  end; // try
	  		  Node := UTMainTree.GetNextSibling(Node);
		  	end;
    	end; // if (not ExitIt) and (not Terminated) then begin
	  end; // for i: = Low(UTBankNodesArr) to ...

		// Pulling root fund data
	  for i := Low(UTFundNodesArr) to High(UTFundNodesArr) do begin
  	  if (UTFundNodesArr[i] = nil) or (UTOrgsNodesArr[i] = nil) then continue;
	  	if (not ExitIt) and (not Terminated) then begin
{$IFDEF FAFH}
      	// check Founder feature
    	  NodeData := UTMainTree.GetNodeData(UTOrgsNodesArr[i]);
				bIsFndr := PrivPresentMO(NodeData.descr, 'b0');
{$ENDIF}
  	    NodeData := UTMainTree.GetNodeData(UTFundNodesArr[i]);
  		  LDataset.SQL.Text := 'SELECT SUM(`balance`)AS`balance`FROM`' + NodeData.link + '`';
{$IFDEF FAFH}
		  	LDataset.SQL.Text := LDataset.SQL.Text + 'WHERE`fnd`<=' + IntToStr(integer(bIsFndr));
{$ENDIF}

{$IFDEF THREADSDBGOUTPUT}
      	OutputDebugString(PWideChar(LDataset.SQL.Text));
{$ENDIF}
		    try
  		  	LDataset.Open;
	  		  if LDataset.RecordCount > 0 then
  				  UTValue := LDataset.FieldByName('balance').AsFloat
	    		else
  	  			UTValue := 0;
	    	  UTCurNode	:= UTFundNodesArr[i];
  	    	Synchronize(UpdateNodeValue);
	  	  except
     		  on e: EZSQLException do begin
{$IFDEF THREADSDBGOUTPUT}
        	  OutputDebugString(PWideChar(IntToStr(e.ErrorCode) + ': ' + e.StatusCode + ' ' + e.Message));
{$ENDIF}
            RCNeeded := (e.ErrorCode = MYSWLSERVERSHUTDOWNIP) or (e.ErrorCode = MYSQLSEVERHASGONEAWAY);
	          break;
  	      end;
	  	  end;
  	  	UpdateFunds(UTFundNodesArr[i]);
		  end; // if (not ExitIt) and (not Terminated)...
  	end; // for i: = Low(UTFundNodesArr) to ...
	  PostMessage(MFPF.Handle, UM_BKGUPDATEFINISHED, 0, 0);
  end; // while (not ExitIt) and (not Terminated)

  try
	  LDataset.Free;
	  UTLConnection.Free;
  finally

  end;

{$IFDEF THREADSDBGOUTPUT}
  OutputDebugString('---- Update thread leaving');
{$ENDIF}
end;

procedure TUpdateThread.UpdateNodeValue;
begin
  if (not Terminated) and (UTCurNode <> nil) then begin
    UTCurNodeData	:= UTMainTree.GetNodeData(UTCurNode);
    UTCurNodeData.balance	:= UTValue;
{$IFDEF THREADSDBGOUTPUT}
//    OutputDebugString(PWideChar('---- Update thread: updating main tree (' + IntToStr(integer(pointer(UTMainTree))) + ')'));
{$ENDIF}
    UTMainTree.RepaintNode(UTCurNode);
    UTCurNode := nil;
  end;
end;

end.
