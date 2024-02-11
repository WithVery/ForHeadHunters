{DEFINE FORPERFORMIA}

{DEFINE MEDIALINK}

{DEFINE HELPCG}

{DEFINE AKNIET}

{DEFINE AKNIETWLAUNCHER}

{DEFINE MOVATORS}

{$DEFINE FPGENERAL}

{$DEFINE NOVIS} // persons as creditors for NOVIS

{DEFINE SHOWFINSTATS}

{$IFDEF MEDIALINK} //multi-org version, witOUT org wizzard
  {DEFINE ORGWIZ}
  {DEFINE INCPLANINEXCEL}                // income plan is written into excel table
  {DEFINE ENCRYPTMYSQLTRAFFIC}          // encrypt traffic to and from server with SSL
  {DEFINE SHOWFINSTATS}
{$ENDIF}

{$IFDEF MOVATORS} // multi-org version, with org Wizzard: Movators, encrypted traffic
  {$DEFINE ORGWIZ}
{$ENDIF}

{$IFDEF HELPCG} //multi-org version, WITH org wizzard
  {$DEFINE ORGWIZ}
  {DEFINE INCPLANINEXCEL}                // income plan is written into excel table
  {$DEFINE ENCRYPTMYSQLTRAFFIC}          // encrypt traffic to and from server with SSL
  {DEFINE RWLO}                         // (R)un (W)ith (L)auncher (O)nly
{$ENDIF}

{$IFDEF FORPERFORMIA} // single-org version
  {$DEFINE RWLO}                         // (R)un (W)ith (L)auncher (O)nly
{$ENDIF}

{$IFDEF FPGENERAL}                      // multi-org version, SSL, witOUT org wizzard
  {DEFINE DEBUGAST}         					 //
  {$DEFINE NATPRINT}         					 	// native printing
  {DEFINE ENCRYPTMYSQLTRAFFIC}         // encrypt traffic to and from server with SSL

  {$DEFINE ORGWIZ}
  {DEFINE RWLO}                         // (R)un (W)ith (L)auncher (O)nly
  {DEFINE TLOG}                         // with (T)able (LOG)ging -- TEMP 8/2/21
  {$DEFINE SFIAF}                        // (S)ort (F)unds (I)n (A)llocation (F)orm - By request from RECOM
  {$DEFINE USERID}                       // Each operation in bank or fond is marked with UserID
  {$DEFINE STOREATTASFILES}              // Store Attachments as files on the web-server
  {$DEFINE FILTERS}                      // Filters for POs
  {DEFINE SHOWFINSTATS}
  {$DEFINE FAFH}                         // (F)ounder's (A)ssets and (F)unds are (H)ideable
	{$IFNDEF FAFH}                      // multi-org version, SSL, witOUT org wizzard
	  {$DEFINE FCBF}                         // with (F)und (C)an (B)e a (F)older -- multi-level funds is available
  {$ELSIF}
	  {$UNDEFINE FCBF}                         // with (F)und (C)an (B)e a (F)older -- multi-level funds is available
	{$ENDIF}
{$ENDIF}


