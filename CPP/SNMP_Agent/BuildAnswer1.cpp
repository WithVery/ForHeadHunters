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
