

// SNMP2Dlg.cpp : implementation file
//

#include "stdafx.h"

#include "SNMP2.h"
#include "SNMP2Dlg.h"
#include "afxdialogex.h"

/*
oid             objid_enterprise[] = { 1, 3, 6, 1, 4, 1, 3, 1, 1 };
oid             objid_sysdescr[] = { 1, 3, 6, 1, 2, 1, 1, 1, 0 };
oid             objid_sysuptime[] = { 1, 3, 6, 1, 2, 1, 1, 3, 0 };
oid             objid_snmptrap[] = { 1, 3, 6, 1, 6, 3, 1, 1, 4, 1, 0 };

oid             objid_name2[] = { 1, 3, 6, 1, 5, 5};
//int							name2_length = sizeof(objid_name2);
*/
//*

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

char *_getCommName = "public";
char *_setCommName = "private";

// stuff for files table view - 101
CString strBaseDir = "c:\\";
CString strfcnFilesTable = "1.3.6.1.4.1.27.1.5.1"; // FCN -> product -> fcnFilesTable -> 
CStringArray saFiles;

void ReloadFiles(const CString &aPath);


#define FILETABLE_INDEX (0) // used to (1) in double-column table
#define FILETABLE_NAME	(1) // used to (2) in double-column table



//
// set community name set/get sizes
int _setSize = strlen(_setCommName);
int _getSize = strlen(_getCommName);

//int snmp_errno = 0;

// CAboutDlg dialog used for App About

class CAboutDlg : public CDialogEx {
public:
	CAboutDlg();

// Dialog Data
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Implementation
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(CAboutDlg::IDD) {

}

void CAboutDlg::DoDataExchange(CDataExchange* pDX) {
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// CSNMP2Dlg dialog

UINT MainUDPServerThread (LPVOID lpParam);
int ProcessSNMPRequest(char *_packet, int _size);


CSNMP2Dlg::CSNMP2Dlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(CSNMP2Dlg::IDD, pParent) {
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CSNMP2Dlg::DoDataExchange(CDataExchange* pDX) {
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CSNMP2Dlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_SENDTRAPBUTTON, &CSNMP2Dlg::OnBnClickedSendtrapbutton)
END_MESSAGE_MAP()


// CSNMP2Dlg message handlers
BOOL CSNMP2Dlg::OnInitDialog() {
	CDialogEx::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL) {
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty()) {
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// TODO: Add extra initialization here
	StartUDPSocket("127.0.0.1", 161);

	// 101
	ReloadFiles(strBaseDir);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void ReloadFiles(const CString &aPath){
	// files loading from the folder
	saFiles.RemoveAll();
	{
		//for files:
		CFileFind finder;
		CString ss = strBaseDir;

		// BMPs:
		CString strWildcard(ss);
		strWildcard += _T("*.*");

		int cnt = 0; // so far we can do only 254 items
		BOOL bWorking = finder.FindFile(strWildcard);
		while(bWorking) {
			bWorking = finder.FindNextFile();
			// skip . and .. files; otherwise, we'd recur infinitely!
			if (finder.IsDots())
				continue;
			else {
				saFiles.Add(finder.GetFileName());
				if(cnt++ > 254)
					break;
			}
		}
		finder.Close();
	}
	// end of files loading

}



typedef struct  {
	CString uaddress;
	int uport;
} udpparams;

void CSNMP2Dlg::StartUDPSocket(CString aaddres, int aport) {
	// Initialize Winsock
	WSADATA wsaData = {0};
  int iResult = WSAStartup(MAKEWORD(2, 2), &wsaData);
  if (iResult != 0) {
		wprintf(L"WSAStartup failed: %d\n", iResult);
		return;
  }

	// start the proccess to open UDP SERVER 
		CWinThread *pUDPServerThread;
		// Staring UDP SERVER
		udpparams *uParams = new udpparams;
		uParams->uaddress = "127.0.0.1";
		uParams->uport		 = aport;
		pUDPServerThread = AfxBeginThread(MainUDPServerThread, (LPVOID)uParams, THREAD_PRIORITY_BELOW_NORMAL);
		if(NULL == pUDPServerThread) {
			TRACE("UDP server thread was not launched. CreateThread() failed: %d\n", GetLastError());
		}

//		CloseHandle(hMainServerThread);

}

void CSNMP2Dlg::OnSysCommand(UINT nID, LPARAM lParam) {
	if ((nID & 0xFFF0) == IDM_ABOUTBOX) {
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else {
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CSNMP2Dlg::OnPaint() {
	if (IsIconic()) {
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else {
		CDialogEx::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CSNMP2Dlg::OnQueryDragIcon() {
	return static_cast<HCURSOR>(m_hIcon);
}

// Main thread for UDP server	
UINT MainUDPServerThread (LPVOID lpParam) {

	udpparams *params = (udpparams *)lpParam;

	CString sMsg;
	struct sockaddr_in	local;
	char buff[2048 * 2];

	DWORD wLength;
	DWORD	wCode;
	char *szStr;
	
	SOCKET sUDP = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (SOCKET_ERROR == sUDP) {
		sMsg.Format("socket() failed. Error code: %d\n", WSAGetLastError());
		TRACE(sMsg);
		return 1;
	}
	else {
		TRACE("socket() call for UDP server successfull.");
	}

	local.sin_family			= AF_INET;
	local.sin_addr.s_addr = inet_addr(params->uaddress);
	local.sin_port				= htons(params->uport);

	if(::bind(sUDP, (struct sockaddr *)&local, sizeof(local)) == SOCKET_ERROR) {
		sMsg.Format("bind() failed. Error code: %d\n", WSAGetLastError());
		TRACE(sMsg);
		return 0;
	}
	else {
		TRACE("bind() call for UDP server was successful.\n");
	}

	// set proper parameters;
	DWORD dwDelay = 100;
	int   dwDelLen = sizeof(dwDelay);
	int iResult = getsockopt(sUDP, SOL_SOCKET, SO_RCVTIMEO, (char *) &dwDelay, &dwDelLen);
  if (iResult == SOCKET_ERROR) {
      TRACE(L"getsockopt for SO_KEEPALIVE failed with error: %u\n", WSAGetLastError());
  }
	else {
      TRACE(L"SO_KEEPALIVE Value: %ld\n", dwDelay);
	}

	while(1) {
		sockaddr_in  client_addr;
    int client_addr_size = sizeof(client_addr);
		int bsize						 = recvfrom(sUDP, buff, 2048, 0, (sockaddr*) &client_addr, &client_addr_size);

    if(bsize == SOCKET_ERROR) {
			sMsg.Format("recvfrom() error: %d\n", WSAGetLastError());
			TRACE(sMsg);
			if(WSAGetLastError() == WSAETIMEDOUT) {
				continue;
			}
			continue;
		}

		int answersize = ProcessSNMPRequest(buff, bsize);

		if(answersize != 0) {

			//---------------------------------------------
			// Send a datagram to the receiver
			TRACE(L"Sending a datagram to the receiver...\n");
			int iResult = sendto(sUDP, (char*)buff, answersize, 0, (sockaddr *) &client_addr, sizeof (client_addr));
			if (iResult == SOCKET_ERROR) {
					TRACE(L"sendto failed with error: %d\n", WSAGetLastError());
					return SNMP_API_STAT_SUCCESS;
			}
		}
	}
	TRACE("UDP server thread exit.\n");
	return 0;
}

SNMP_API_STAT_CODES ParsePacket(byte *_packet, int _size, SNMP_PDU *pdu) {
  char *community;
  // sequence length
  byte seqLen;
  // version
  byte verLen, verEnd;
  // community string
  byte comLen, comEnd;
  // pdu
  byte pduTyp, pduLen;
  byte ridLen, ridEnd;
  byte errLen, errEnd;
  byte eriLen, eriEnd;
  byte vblTyp, vblLen;
  byte vbiTyp, vbiLen;
  byte obiLen, obiEnd;
  byte valTyp, valLen, valEnd;
  byte i;
  //
  // reset packet array
  //memset(_packet, 0, SNMP_MAX_PACKET_LEN);
  //
  // validate packet
  if ( _size != 0 && _size > SNMP_MAX_PACKET_LEN ) {
    //
    //SNMP_FREE(_packet);

    return SNMP_API_STAT_PACKET_TOO_BIG;
  }
  //
  // packet check 1
  if ( _packet[0] != 0x30 ) {
    //
    //SNMP_FREE(_packet);

    return SNMP_API_STAT_PACKET_INVALID;
  }
  //
  // sequence length
  seqLen = _packet[1];
  // version
  verLen = _packet[3];
  verEnd = 3 + verLen;
  // community string
  comLen = _packet[verEnd + 2];
  comEnd = verEnd + 2 + comLen;
  // pdu
  pduTyp = _packet[comEnd + 1];
  pduLen = _packet[comEnd + 2];
  ridLen = _packet[comEnd + 4];
  ridEnd = comEnd + 4 + ridLen;
  errLen = _packet[ridEnd + 2];
  errEnd = ridEnd + 2 + errLen;
  eriLen = _packet[errEnd + 2];
  eriEnd = errEnd + 2 + eriLen;
  vblTyp = _packet[eriEnd + 1];
  vblLen = _packet[eriEnd + 2];
  vbiTyp = _packet[eriEnd + 3];
  vbiLen = _packet[eriEnd + 4];
  obiLen = _packet[eriEnd + 6];
  obiEnd = eriEnd + obiLen + 6;
  valTyp = _packet[obiEnd + 1];
  valLen = _packet[obiEnd + 2];
  valEnd = obiEnd + 2 + valLen;
  //
  // extract version
  pdu->version = 0;
  for ( i = 0; i < verLen; i++ ) {
    pdu->version = (pdu->version << 8) | _packet[5 + i];
  }
  //
  // validate version
  //
  // pdu-type
  pdu->type = (SNMP_PDU_TYPES)pduTyp;
//  _dstType = pdu->type;
  //
  // validate community size
  if ( comLen > SNMP_MAX_NAME_LEN ) {
    // set pdu error
    pdu->error = SNMP_ERR_TOO_BIG;
    //
    return SNMP_API_STAT_NAME_TOO_BIG;
  }
  //
  //
  // validate community name
  if ( pdu->type == SNMP_PDU_SET && comLen == _setSize ) {
    //
    for ( i = 0; i < _setSize; i++ ) {
      if( _packet[verEnd + 3 + i] != (byte)_setCommName[i] ) {
        // set pdu error
        pdu->error = SNMP_ERR_NO_SUCH_NAME;
        //
        return SNMP_API_STAT_NO_SUCH_NAME;
      }
    }
  } else if ( pdu->type == SNMP_PDU_GET && comLen == _getSize ) {
    //
    for ( i = 0; i < _getSize; i++ ) {
      if( _packet[verEnd + 3 + i] != (byte)_getCommName[i] ) {
        // set pdu error
        pdu->error = SNMP_ERR_NO_SUCH_NAME;
        //
        return SNMP_API_STAT_NO_SUCH_NAME;
      }
    }
  } else if (!((pdu->type == SNMP_PDU_GET_NEXT) || (pdu->type == SNMP_PDU_WALK))) {
    // set pdu error
    pdu->error = SNMP_ERR_NO_SUCH_NAME;
    //
    return SNMP_API_STAT_NO_SUCH_NAME;
  }
/* original version
  } else {
    // set pdu error
    pdu->error = SNMP_ERR_NO_SUCH_NAME;
    //
    return SNMP_API_STAT_NO_SUCH_NAME;
  }
	*/
  //
  //
  // extract reqiest-id 0x00 0x00 0x00 0x01 (4-byte int aka int32)
  pdu->requestId = 0;
  for ( i = 0; i < ridLen; i++ ) {
    pdu->requestId = (pdu->requestId << 8) | _packet[comEnd + 5 + i];
  }
  //
  // extract error 
  pdu->error = SNMP_ERR_NO_ERROR;
  int32_t err = 0;
  for ( i = 0; i < errLen; i++ ) {
    err = (err << 8) | _packet[ridEnd + 3 + i];
  }
  pdu->error = (SNMP_ERR_CODES)err;
  //
  // extract error-index 
  pdu->errorIndex = 0;
  for ( i = 0; i < eriLen; i++ ) {
    pdu->errorIndex = (pdu->errorIndex << 8) | _packet[errEnd + 3 + i];
  }
  //
  //
  // validate object-identifier size
  if ( obiLen > SNMP_MAX_OID_LEN ) {
    // set pdu error
    pdu->error = SNMP_ERR_TOO_BIG;

    return SNMP_API_STAT_OID_TOO_BIG;
  }
  //
  // extract and contruct object-identifier
  memset(pdu->OID.data, 0, SNMP_MAX_OID_LEN);
  pdu->OID.size = obiLen;
  for ( i = 0; i < obiLen; i++ ) {
    pdu->OID.data[i] = _packet[eriEnd + 7 + i];
  }
  //
  // value-type
  pdu->VALUE.syntax = (SNMP_SYNTAXES)valTyp;
  //
  // validate value size
  if ( obiLen > SNMP_MAX_VALUE_LEN ) {
    // set pdu error
    pdu->error = SNMP_ERR_TOO_BIG;

    return SNMP_API_STAT_VALUE_TOO_BIG;
  }
  //
  // value-size
  pdu->VALUE.size = valLen;
  //
  // extract value
  memset(pdu->VALUE.data, 0, SNMP_MAX_VALUE_LEN);
  for ( i = 0; i < valLen; i++ ) {
    pdu->VALUE.data[i] = _packet[obiEnd + 3 + i];
  }
  //
  return SNMP_API_STAT_SUCCESS;
}

SNMP_API_STAT_CODES BuildAnswer1(byte *_packet, int *_size, SNMP_PDU *pdu, SNMP_PDU *pdu2) {
  int32_u u;
  byte i;
  //
  // Length of entire SNMP packet
  int _packetPos = 0;  // 23
  //
  memset(_packet, 0, SNMP_MAX_PACKET_LEN);
	char *ww;

	ww = (char *)_packet;
  //

	//
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_SEQUENCE;     // type
	_packetPos++;
  //
  // SNMP version
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_INT;  // type
  _packet[_packetPos++] = 0x01;                   // length
  _packet[_packetPos++] = 0x00;                   // value
  //
  // SNMP community string
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_OCTETS;       // type
  if(pdu->type == SNMP_PDU_SET) {
    _packet[_packetPos++] = (byte)_setSize; // length
    for(i = 0; i < _setSize; i++) {
      _packet[_packetPos++] = (byte)_setCommName[i];
    }
  }
	else {
    _packet[_packetPos++] = (byte)_getSize; // length
    for(i = 0; i < _getSize; i++) {
      _packet[_packetPos++] = (byte)_getCommName[i];
    }
  }

  //
#define VARBINDLIST_HEADER_SIZE (2)
#define VARBIND_SEQ_SIZE		(2)
#define VAR_HEADER_SIZE			(2)
#define NUM_OF_VARS					(2)

  // SNMP PDU
  _packet[_packetPos++] = (byte)pdu->type;
	int hsizes = VAR_HEADER_SIZE * 3 + VARBINDLIST_HEADER_SIZE + (VARBIND_SEQ_SIZE + VAR_HEADER_SIZE * 2) * NUM_OF_VARS;
  _packet[_packetPos++] = (byte)(sizeof(pdu->requestId) + sizeof((int32_t)pdu->error) + sizeof(pdu->errorIndex) + 
																	pdu->OID.size + pdu->VALUE.size + pdu2->OID.size + pdu2->VALUE.size + hsizes);
  //
  // Request ID (size always 4 e.g. 4-byte int)
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_INT;  // type
  _packet[_packetPos++] = (byte)sizeof(pdu->requestId);
  u.int32 = pdu->requestId;
  _packet[_packetPos++] = u.data[3];
  _packet[_packetPos++] = u.data[2];
  _packet[_packetPos++] = u.data[1];
  _packet[_packetPos++] = u.data[0];
  //
  // Error (size always 4 e.g. 4-byte int)
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_INT;  // type
  _packet[_packetPos++] = (byte)sizeof((int32_t)pdu->error);
  u.int32 = pdu->error;
  _packet[_packetPos++] = u.data[3];
  _packet[_packetPos++] = u.data[2];
  _packet[_packetPos++] = u.data[1];
  _packet[_packetPos++] = u.data[0];
  //
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_INT;  // type
  _packet[_packetPos++] = (byte)sizeof(pdu->errorIndex);
  u.int32 = pdu->errorIndex;
  _packet[_packetPos++] = u.data[3];
  _packet[_packetPos++] = u.data[2];
  _packet[_packetPos++] = u.data[1];
  _packet[_packetPos++] = u.data[0];
  //
  // Varbind List
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_SEQUENCE;     // type
	int vblhsize = (VARBIND_SEQ_SIZE + VAR_HEADER_SIZE * 2) * NUM_OF_VARS;
	_packet[_packetPos++] = (byte)( pdu->OID.size + pdu->VALUE.size + pdu2->OID.size + pdu2->VALUE.size + vblhsize); //4

  // Varbind
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_SEQUENCE;     // type
	int vbhsize = (VAR_HEADER_SIZE * 2);
  _packet[_packetPos++] = (byte)( pdu->OID.size + pdu->VALUE.size + vbhsize); //2

  //
  // ObjectIdentifier
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_OID;  // type
  _packet[_packetPos++] = (byte)(pdu->OID.size);
  for(i = 0; i < pdu->OID.size; i++ ) {
		_packet[_packetPos++] = pdu->OID.data[i];
  }
  //
  // Value
  _packet[_packetPos++] = (byte)pdu->VALUE.syntax;        // type
  _packet[_packetPos++] = (byte)(pdu->VALUE.size);
  for(i = 0; i < pdu->VALUE.size; i++ ) {
    _packet[_packetPos++] = pdu->VALUE.data[i];
  }


	//second variable
  // Varbind
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_SEQUENCE;     // type
  _packet[_packetPos++] = (byte)(pdu2->OID.size + pdu2->VALUE.size + vbhsize); //2

  // ObjectIdentifier
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_OID;  // type
  _packet[_packetPos++] = (byte)(pdu2->OID.size);
  for(i = 0; i < pdu2->OID.size; i++ ) {
		_packet[_packetPos++] = pdu2->OID.data[i];
  }
  //
  // Value
  _packet[_packetPos++] = (byte)pdu2->VALUE.syntax;        // type
  _packet[_packetPos++] = (byte)(pdu2->VALUE.size);
  for(i = 0; i < pdu2->VALUE.size; i++ ) {
    _packet[_packetPos++] = pdu2->VALUE.data[i];
  }

  _packet[1] = _packetPos;
	*_size = _packetPos + 2;
	return SNMP_API_STAT_SUCCESS;
}

SNMP_API_STAT_CODES BuildAnswer(byte *_packet, int *_size, SNMP_PDU *pdu) {
  int32_u u;
  byte i;
  //
  // Length of entire SNMP packet
  int _packetPos = 0;  // 23
  int _packetSize = 25 + sizeof(pdu->requestId) + sizeof(pdu->error) + sizeof(pdu->errorIndex) + pdu->OID.size + pdu->VALUE.size; // original version

  //
  memset(_packet, 0, SNMP_MAX_PACKET_LEN);
  //
//  if(_dstType == SNMP_PDU_SET) {
	if(pdu->type == SNMP_PDU_SET) {
    _packetSize += _setSize;
  }
	else {
    _packetSize += _getSize;
  }
  //
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_SEQUENCE;     // type
  _packet[_packetPos++] = (byte)_packetSize - 2;          // length
  //
  // SNMP version
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_INT;  // type
  _packet[_packetPos++] = 0x01;                   // length
  _packet[_packetPos++] = 0x00;                   // value
  //
  // SNMP community string
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_OCTETS;       // type
  if(pdu->type == SNMP_PDU_SET) {
    _packet[_packetPos++] = (byte)_setSize; // length
    for(i = 0; i < _setSize; i++) {
      _packet[_packetPos++] = (byte)_setCommName[i];
    }
  }
	else {
    _packet[_packetPos++] = (byte)_getSize; // length
    for(i = 0; i < _getSize; i++) {
      _packet[_packetPos++] = (byte)_getCommName[i];
    }
  }

  //
  // SNMP PDU
  _packet[_packetPos++] = (byte)pdu->type;
  _packet[_packetPos++] = (byte)( sizeof(pdu->requestId) + sizeof((int32_t)pdu->error) + sizeof(pdu->errorIndex) + pdu->OID.size + pdu->VALUE.size + 14 );
  //
  // Request ID (size always 4 e.g. 4-byte int)
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_INT;  // type
  _packet[_packetPos++] = (byte)sizeof(pdu->requestId);
  u.int32 = pdu->requestId;
  _packet[_packetPos++] = u.data[3];
  _packet[_packetPos++] = u.data[2];
  _packet[_packetPos++] = u.data[1];
  _packet[_packetPos++] = u.data[0];
  //
  // Error (size always 4 e.g. 4-byte int)
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_INT;  // type
  _packet[_packetPos++] = (byte)sizeof((int32_t)pdu->error);
  u.int32 = pdu->error;
  _packet[_packetPos++] = u.data[3];
  _packet[_packetPos++] = u.data[2];
  _packet[_packetPos++] = u.data[1];
  _packet[_packetPos++] = u.data[0];
  //
  // Error Index (size always 4 e.g. 4-byte int)
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_INT;  // type
  _packet[_packetPos++] = (byte)sizeof(pdu->errorIndex);
  u.int32 = pdu->errorIndex;
  _packet[_packetPos++] = u.data[3];
  _packet[_packetPos++] = u.data[2];
  _packet[_packetPos++] = u.data[1];
  _packet[_packetPos++] = u.data[0];
  //
  // Varbind List
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_SEQUENCE;     // type
	_packet[_packetPos++] = (byte)( pdu->OID.size + pdu->VALUE.size + 6 ); //4
//
  // Varbind
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_SEQUENCE;     // type
  _packet[_packetPos++] = (byte)( pdu->OID.size + pdu->VALUE.size + 4 ); //2
  //
  // ObjectIdentifier
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_OID;  // type
  _packet[_packetPos++] = (byte)(pdu->OID.size);
  for(i = 0; i < pdu->OID.size; i++ ) {
		_packet[_packetPos++] = pdu->OID.data[i];
  }
  //
  // Value
  _packet[_packetPos++] = (byte)pdu->VALUE.syntax;        // type
  _packet[_packetPos++] = (byte)(pdu->VALUE.size);
  for(i = 0; i < pdu->VALUE.size; i++ ) {
    _packet[_packetPos++] = pdu->VALUE.data[i];
  }

	*_size = _packetSize;
	return SNMP_API_STAT_SUCCESS;
}

int ProcessSNMPRequest(char *_packet, int _size) {

	SNMP_PDU ar;

	ParsePacket((byte *)_packet, _size, &ar);
//	SNMP_PDU ar2;
//	ParsePacket((byte *)_packet, _size, &ar2);

	// process the request itself
	CString qqq;
	char *buf = qqq.GetBuffer(1024);
	ar.OID.toString(buf);
	qqq.ReleaseBuffer();
//			qqq.AppendFormat("\n");
//	TRACE(qqq);
	switch(ar.type) {
	case SNMP_PDU_GET      : TRACE("SNMP_PDU_GET\n"); break;
	case SNMP_PDU_GET_NEXT : TRACE("SNMP_PDU_GET_NEXT\n"); break;
	case SNMP_PDU_RESPONSE : TRACE("SNMP_PDU_RESPONSE\n"); break;
	case SNMP_PDU_SET      : TRACE("SNMP_PDU_SET      \n"); break;
	case SNMP_PDU_TRAP     : TRACE("SNMP_PDU_TRAP     \n"); break;
	case SNMP_PDU_WALK     : TRACE("SNMP_PDU_WALK     \n"); break;
	}

	BOOL bSkipPacket = TRUE;
	TRACE("%s\n", qqq);
	// process the request itself
	if(qqq == "1.3.6.1.4.1.27.1.1.0") { // private->enterprise
		ar.OID.fromString("1.3.6.1.4.1.27.1.1");
		ar.type = SNMP_PDU_RESPONSE;
		ar.error = SNMP_ERR_NO_ERROR;
		COleDateTime cnow = COleDateTime::GetCurrentTime(); 
		cnow.Format();
		ar.VALUE.encode(SNMP_SYNTAX_OCTETS, cnow.Format());
		bSkipPacket = FALSE;
	}
	// 101 - the new part, for "table view"
	else if (qqq == strfcnFilesTable) {
		if(ar.type == SNMP_PDU_GET_NEXT) {
			ar.OID.fromString2(strfcnFilesTable + ".1.1");
			ar.type = SNMP_PDU_RESPONSE;
			ar.error = SNMP_ERR_NO_ERROR;
			ar.VALUE.syntax = SNMP_SYNTAX_INT;
			int16_t v = 1;
			ar.VALUE.encode(SNMP_SYNTAX_INT, &v);
			bSkipPacket = FALSE;
		}
	}
	else if (qqq.Find(strfcnFilesTable) > -1) {
		CString strTail = qqq.Mid(strfcnFilesTable.GetLength() + 1); // it contains two variables: <fieldID>:<InstanceID of the table>
		int iFieldID = 0;
		int iInstanceID	 = 0;
		sscanf(strTail, "%u.%u", &iFieldID, &iInstanceID);
		if(ar.type == SNMP_PDU_GET) {
			if(iFieldID == FILETABLE_INDEX) { // fcnftIndex field
				ar.type = SNMP_PDU_RESPONSE;
				ar.error = SNMP_ERR_NO_ERROR;
				ar.VALUE.syntax = SNMP_SYNTAX_INT;
				int16_t v = iInstanceID;
				ar.VALUE.encode(SNMP_SYNTAX_INT, &v);
			}
			else if (iFieldID == FILETABLE_NAME) { // fcnftName field
				ar.type = SNMP_PDU_RESPONSE;
				ar.error = SNMP_ERR_NO_ERROR;
				ar.VALUE.syntax = SNMP_SYNTAX_OCTETS;
				int16_t v = iInstanceID;
				ar.VALUE.encode(SNMP_SYNTAX_OCTETS, saFiles[iInstanceID - 1]);
			}
			bSkipPacket = FALSE;
		}
		else if(ar.type == SNMP_PDU_GET_NEXT) { // sent next OID or finish
			CString strNewOID = strfcnFilesTable;
			if((iInstanceID > 253) || (iInstanceID >= saFiles.GetSize() - 1)) {
				iInstanceID = 0;
				strNewOID.AppendFormat(".2.%d", ++iInstanceID);
			}
			else {
				strNewOID.AppendFormat(".1.%d", ++iInstanceID);
			}
			
			TRACE("%s\n", strNewOID);
			ar.OID.fromString2(strNewOID);
			ar.type = SNMP_PDU_RESPONSE;
			ar.error = SNMP_ERR_NO_ERROR;
			if(iInstanceID == 1) { // we've done, send a terminator
				ar.VALUE.syntax = SNMP_SYNTAX_INT;
				CString v = "";
				ar.VALUE.encode(SNMP_SYNTAX_OCTETS, v);
			}
			else {
				ar.VALUE.syntax = SNMP_SYNTAX_INT;
				int16_t v = iInstanceID;
				ar.VALUE.encode(SNMP_SYNTAX_INT, &v);
			}
			bSkipPacket = FALSE;
		}
	}

//=============  SET REQUEST PROCESSING  ==================
	else if (qqq == "1.3.6.1.4.1.27.1.6.0") { // fcnpath variable, see new FCN-MIB file
		if(ar.type == SNMP_PDU_SET) {
			// pull new variable value from request
			CString strAnswer;
			char *buf1 = strAnswer.GetBuffer(1024);
			ar.VALUE.decode(buf1, 1024);
			strAnswer.ReleaseBuffer();
			strBaseDir = strAnswer;
			ReloadFiles(strBaseDir);
		}

		// build an answer to the manager to show that the variable has been changed
		ar.type = SNMP_PDU_RESPONSE;
		ar.error = SNMP_ERR_NO_ERROR;
		ar.VALUE.encode(SNMP_SYNTAX_OCTETS, strBaseDir);
		bSkipPacket = FALSE;

	}

	// 101 - the new part, for "table view"
	if(bSkipPacket) {
		return 0;
	}

	BuildAnswer((byte *)_packet, &_size, &ar);
//	BuildAnswer1((byte *)_packet, &_size, &ar, &ar2);

	return _size;

}

//SNMP_API_STAT_CODES BuildTrap(byte *_packet, int *_size, SNMP_PDU *pdu, SNMP_PDU *pdu2) {
SNMP_API_STAT_CODES BuildTrap(byte *_packet, int *_size) {
  byte i;
  //
  // Length of entire SNMP packet
  int _packetPos = 0;  // 23
  //
  memset(_packet, 0, SNMP_MAX_PACKET_LEN);

	//
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_SEQUENCE;     // type
	_packetPos++;																						// total length of packet comes here - we set it up in the end

	// SNMP version
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_INT;  // type
  _packet[_packetPos++] = 0x01;                   // length
  _packet[_packetPos++] = 0x01;                   // value - 1 for v2c

  //
  // SNMP community string
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_OCTETS;       // type
  _packet[_packetPos++] = (byte)_getSize; // length
  for(i = 0; i < _getSize; i++) {
    _packet[_packetPos++] = (byte)_getCommName[i];
  }


#define VARBINDLIST_HEADER_SIZE (2)
#define VARBIND_SEQ_SIZE				(2)
#define VAR_HEADER_SIZE					(2)
// 2VARBIND
#define NUM_OF_VARS							(4)

  // Timeticks setup
	CString sTimeTicksOID = "1.3.6.1.2.1.1.3.0";  // sysUpTime
	SNMP_PDU pduTimeTicks;
	pduTimeTicks.OID.fromString2(sTimeTicksOID);
	uint32_t uptime = GetTickCount() / 10;
	pduTimeTicks.VALUE.encode(SNMP_SYNTAX_TIME_TICKS, uptime);
	int iTimeTicksOIDlen = pduTimeTicks.OID.size + pduTimeTicks.VALUE.size + (VAR_HEADER_SIZE * 2); // - 1;

  // OID ID setup
	CString sOIDID = "1.3.6.1.6.3.1.1.4.1.0"; // snmpTrapOID 

	SNMP_PDU pduOIDID;
	pduOIDID.OID.fromString2(sOIDID);
	SNMP_OID oidOIDToPass;
	oidOIDToPass.fromString2("1.3.6.1.4.1.27.3");

	memcpy(&pduOIDID.VALUE.data, &oidOIDToPass.data, oidOIDToPass.size);
	pduOIDID.VALUE.size = oidOIDToPass.size; 
	int iOIDIDlen =  pduOIDID.OID.size + pduOIDID.VALUE.size + VAR_HEADER_SIZE * 2;

	// 2VARBIND
  // OID ID Value setup
	CString sOIDVal = "1.3.6.1.4.1.27.1.7"; // fcnerrorcode
	SNMP_PDU pduOIDVal;
	pduOIDVal.OID.fromString2(sOIDVal);
	int iSomeError = 15;
	pduOIDVal.VALUE.encode(SNMP_SYNTAX_INT, iSomeError);
//	pduOIDVal.VALUE.encode(SNMP_SYNTAX_OCTETS, strBaseDir); // as an example we can use it

	int iOIDVallen = pduOIDVal.OID.size + pduOIDVal.VALUE.size + VAR_HEADER_SIZE * 2;

	// 2VARBIND
  // OID ID Value setup
	CString sOIDVal2 = "1.3.6.1.4.1.27.1.8"; // fcnerrorinfo
	SNMP_PDU pduOIDVal2;
	pduOIDVal2.OID.fromString2(sOIDVal2);
	pduOIDVal2.VALUE.encode(SNMP_SYNTAX_OCTETS, "Some error info goes here...");

	int iOIDVal2len = pduOIDVal2.OID.size + pduOIDVal2.VALUE.size + VAR_HEADER_SIZE * 2;

	// 2VARBIND
	int iVarBindListsize = iTimeTicksOIDlen + iOIDIDlen + iOIDVallen + iOIDVal2len + VAR_HEADER_SIZE * NUM_OF_VARS;
	int iPDUsize = iVarBindListsize + 12;

	// SNMP TRAP PDU
	// TRAP TYPE
  _packet[_packetPos++] = (byte)SNMP_PDU_TRAP2;
  _packet[_packetPos++] = iPDUsize; 

	//
  // Request ID (size always 2 e.g. 2-byte int)
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_INT;  // type
  _packet[_packetPos++] = (byte)2;
	// Requst ID Generation
  int16_u u;
	srand(time(NULL));
	u.int16 = rand();
  _packet[_packetPos++] = u.data[1];
  _packet[_packetPos++] = u.data[0];

  //
  // Error-status (size is always 1-byte int)
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_INT;  // type
  _packet[_packetPos++] = 1;
  _packet[_packetPos++] = 0;

  // Error-index (size is always 1-byte int)
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_INT;  // type
  _packet[_packetPos++] = 1;
  _packet[_packetPos++] = 0;

  //
  // Varbind List
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_SEQUENCE;     // type
	_packet[_packetPos++] = (byte)(iVarBindListsize); //4

	// First variable - timeticks
  //Varbind
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_SEQUENCE;     // type
  _packet[_packetPos++] = (byte)(iTimeTicksOIDlen); //2
	
  // ObjectIdentifier
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_OID; //SNMP_SYNTAX_TIME_TICKS;  // type
  _packet[_packetPos++] = (byte)(pduTimeTicks.OID.size);
  for(i = 0; i < pduTimeTicks.OID.size; i++ ) {
		_packet[_packetPos++] = pduTimeTicks.OID.data[i];
  }
  //
  // Value
  _packet[_packetPos++] = (byte)(pduTimeTicks.VALUE.syntax);        // type
  _packet[_packetPos++] = (byte)(pduTimeTicks.VALUE.size);
  for(i = 0; i < pduTimeTicks.VALUE.size; i++ ) {
    _packet[_packetPos++] = pduTimeTicks.VALUE.data[i];
  }

	//second variable - OID ID to pass in the trap
  // Varbind
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_SEQUENCE;     // type
  _packet[_packetPos++] = (byte)(iOIDIDlen); //2
	

  // ObjectIdentifier
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_OID;  // type
  _packet[_packetPos++] = (byte)(pduOIDID.OID.size);
  for(i = 0; i < pduOIDID.OID.size; i++ ) {
		_packet[_packetPos++] = pduOIDID.OID.data[i];
  }
  //
  // Value
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_OID;        // type
  _packet[_packetPos++] = (byte)(pduOIDID.VALUE.size);
  for(i = 0; i < pduOIDID.VALUE.size; i++ ) {
    _packet[_packetPos++] = pduOIDID.VALUE.data[i];
  }


	//third variable - value of OID ID(second parameter) to pass in the trap
  // Varbind
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_SEQUENCE;     // type
  _packet[_packetPos++] = (byte)(iOIDVallen); //2
	
  // ObjectIdentifier
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_OID;  // type
  _packet[_packetPos++] = (byte)(pduOIDVal.OID.size);
  for(i = 0; i < pduOIDVal.OID.size; i++ ) {
		_packet[_packetPos++] = pduOIDVal.OID.data[i];
  }
  //
  // Value
	_packet[_packetPos++] = (byte)pduOIDVal.VALUE.syntax;        // type
  _packet[_packetPos++] = (byte)(pduOIDVal.VALUE.size);
  for(i = 0; i < pduOIDVal.VALUE.size; i++ ) {
    _packet[_packetPos++] = pduOIDVal.VALUE.data[i];
  }

	// 2VARBIND
  // Varbind
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_SEQUENCE;     // type
  _packet[_packetPos++] = (byte)(iOIDVal2len); //2
	
  // ObjectIdentifier
  _packet[_packetPos++] = (byte)SNMP_SYNTAX_OID;  // type
  _packet[_packetPos++] = (byte)(pduOIDVal2.OID.size);
  for(i = 0; i < pduOIDVal2.OID.size; i++ ) {
		_packet[_packetPos++] = pduOIDVal2.OID.data[i];
  }
  //
  // Value
	_packet[_packetPos++] = (byte)pduOIDVal2.VALUE.syntax;        // type
  _packet[_packetPos++] = (byte)(pduOIDVal2.VALUE.size);
  for(i = 0; i < pduOIDVal2.VALUE.size; i++ ) {
    _packet[_packetPos++] = pduOIDVal2.VALUE.data[i];
  }

	_packet[1] = _packetPos - 2;
	*_size = _packetPos;

	// dump the packet to the file
//	CFile f("c:\\buckbuf1.txt", CFile::modeWrite);
//	f.Write(_packet, _packetPos);
	// dump the packet to the file - end of

	return SNMP_API_STAT_SUCCESS;
}

void CSNMP2Dlg::OnBnClickedSendtrapbutton() {

	char buf[2048 * 2];
	int size;

	SNMP_PDU pdu, pdu2;

	BuildTrap((byte *)buf, &size);

	// send it!
	int iResult;
  WSADATA wsaData;

  SOCKET SendSocket = INVALID_SOCKET;
  sockaddr_in RecvAddr;

	unsigned short Port = 162;

	//---------------------------------------------
	// Create a socket for sending data
	SendSocket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (SendSocket == INVALID_SOCKET) {
			wprintf(L"socket failed with error: %ld\n", WSAGetLastError());
			WSACleanup();
			return;
	}

  //---------------------------------------------
  // Set up the RecvAddr structure with the IP address of
  // the receiver (in this example case "192.168.1.1")
  // and the specified port number.
  RecvAddr.sin_family = AF_INET;
  RecvAddr.sin_port = htons(Port);
  RecvAddr.sin_addr.s_addr = inet_addr("127.0.0.1");

  //---------------------------------------------
  // Send a datagram to the receiver
  //wprintf(L"Sending a datagram to the receiver...\n");
  iResult = sendto(SendSocket, buf, size, 0, (SOCKADDR *) & RecvAddr, sizeof (RecvAddr));
  if (iResult == SOCKET_ERROR) {
      wprintf(L"sendto failed with error: %d\n", WSAGetLastError());
      closesocket(SendSocket);
      WSACleanup();
      return;
  }

  iResult = closesocket(SendSocket);

}

