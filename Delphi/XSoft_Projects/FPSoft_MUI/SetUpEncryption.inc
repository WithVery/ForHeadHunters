  if EncConn then begin
    AConn.Properties.Values['MYSQL_SSL']      := 'TRUE';
    AConn.Properties.Values['MYSQL_SSL_KEY']  := SSLDATAFOLDER + 'client-key.pem';
    AConn.Properties.Values['MYSQL_SSL_CERT'] := SSLDATAFOLDER + 'client-cert.pem';
    AConn.Properties.Values['MYSQL_SSL_CA']   := SSLDATAFOLDER + 'ca-cert.pem';
  end;
