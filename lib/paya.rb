require 'savon'
require 'paya/base'

require 'paya/certification'
require 'paya/certification/ccd'
require 'paya/certification/ppd'
require 'paya/certification/tel'
require 'paya/certification/web'

require 'paya/ccd/guaranteed/credit_debit_transaction'
require 'paya/ccd/guaranteed/debit_transaction'
require 'paya/ccd/non_guaranteed/credit_debit_transaction'
require 'paya/ccd/non_guaranteed/debit_transaction'

require 'paya/ppd/guaranteed/credit_debit_transaction'
require 'paya/ppd/guaranteed/debit_transaction'
require 'paya/ppd/non_guaranteed/credit_debit_transaction'
require 'paya/ppd/non_guaranteed/debit_transaction'

require 'paya/tel/guaranteed/credit_debit_transaction'
require 'paya/tel/guaranteed/debit_transaction'
require 'paya/tel/non_guaranteed/credit_debit_transaction'
require 'paya/tel/non_guaranteed/debit_transaction'

require 'paya/web/guaranteed/credit_debit_transaction'
require 'paya/web/guaranteed/debit_transaction'
require 'paya/web/non_guaranteed/credit_debit_transaction'
require 'paya/web/non_guaranteed/debit_transaction'


module Paya
  CERTITICATION_API_END_POINT = "https://demo.eftchecks.com/webservices/AuthGateway.asmx?WSDL"
  API_END_POINT = "https://getigateway.eftchecks.com/webservices/authgateway.asmx?WSDL"

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

  class << self
    attr_accessor :configuration

    def client
      test_mode ? sandbox_client : live_client
    end

    def live_client
      ::Savon.client(wsdl: Paya::API_END_POINT)
    end

    def sandbox_client
      ::Savon.client(wsdl: Paya::CERTITICATION_API_END_POINT)
    end

    def test_mode
      !Paya.configuration.production
    end

  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end


end
