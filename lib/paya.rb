require 'savon'
Dir.glob("paya/**/*").each {|file| require file }

module Paya
  class << self

    CERTITICATION_API_END_POINT = "https://demo.eftchecks.com/webservices/AuthGateway.asmx?WSDL"
    API_END_POINT = "https://getigateway.eftchecks.com/webservices/authgateway.asmx?WSDL"

    attr_accessor :user_name, :password, :certification_user_name, :certification_password

    PROCESS_SINGLE_CERTIFICATION_CHECK = <<xml
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
<soap:Header>
<AuthGatewayHeader xmlns="http://tempuri.org/GETI.eMagnus.WebServices/AuthGateway">
<UserName>&&&USER_NAME&&&</UserName>
<Password>&&&PASSWORD&&&</Password>
<TerminalID>&&&TERMINAL_ID&&&</TerminalID>
</AuthGatewayHeader>
</soap:Header>
<soap:Body>
<ProcessSingleCertificationCheck xmlns="http://tempuri.org/GETI.eMagnus.WebServices/AuthGateway">
<DataPacket>
&&&DATA_PACKET&&&
</DataPacket>
</ProcessSingleCertificationCheck>
</soap:Body>
</soap:Envelope>
xml

    PROCESS_SINGLE_CHECK = <<xml
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
<soap:Header>
<AuthGatewayHeader xmlns="http://tempuri.org/GETI.eMagnus.WebServices/AuthGateway">
<UserName>&&&USER_NAME&&&</UserName>
<Password>&&&PASSWORD&&&</Password>
<TerminalID>&&&TERMINAL_ID&&&</TerminalID>
</AuthGatewayHeader>
</soap:Header>
<soap:Body>
<ProcessSingleCheck xmlns="http://tempuri.org/GETI.eMagnus.WebServices/AuthGateway">
<DataPacket>
&&&DATA_PACKET&&&
</DataPacket>
</ProcessSingleCheck>
</soap:Body>
</soap:Envelope>
xml

    GET_ARCHIVED_RESPONSE = <<xml
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
<soap:Header>
<AuthGatewayHeader xmlns="http://tempuri.org/GETI.eMagnus.WebServices/AuthGateway">
<UserName>&&&USER_NAME&&&</UserName>
<Password>&&&PASSWORD&&&</Password>
<TerminalID>&&&TERMINAL_ID&&&</TerminalID>
</AuthGatewayHeader>
</soap:Header>
<soap:Body>
<GetArchivedResponse xmlns="http://tempuri.org/GETI.eMagnus.WebServices/AuthGateway">
<RequestId>
&&&REQUEST_ID&&&
</RequestId>
</GetArchivedResponse>
</soap:Body>
</soap:Envelope>
xml


    def client
      ::Savon.client(wsdl: Paya::API_END_POINT, headers: {UserName: Paya.user_name, Password: Paya.password})
    end

    def certification_client
      ::Savon.client(wsdl: Paya::CERTITICATION_API_END_POINT, headers: {UserName: Paya.certification_user_name, Password: Paya.certification_password})
    end


  end
end
