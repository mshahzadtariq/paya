module Paya
  class Base
    CERTITICATION_API_END_POINT = "https://demo.eftchecks.com/webservices/AuthGateway.asmx?WSDL"
    API_END_POINT = "https://getigateway.eftchecks.com/webservices/authgateway.asmx?WSDL"

    PROCESS_SINGLE_CERTIFICATION_CHECK = <<xml
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
<soap:Header>
<AuthGatewayHeader xmlns="http://tempuri.org/GETI.eMagnus.WebServices/AuthGateway">
<UserName>#{USER_NAME}</UserName>
<Password>#{PASSWORD}</Password>
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
<UserName>#{USER_NAME}</UserName>
<Password>#{PASSWORD}</Password>
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
<UserName>#{USER_NAME}</UserName>
<Password>#{PASSWORD}</Password>
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
    def initialize user_name, password
      @client = Savon.client(wsdl: API_END_POINT, headers: {UserName: user_name, Password: password})
      @certification_client = Savon.client(wsdl: CERTITICATION_API_END_POINT, headers: {UserName: user_name, Password: password})
    end

    def process_single_check options={}, terminal_id=nil, identifier='R'
      @terminal_id = terminal_id.to_s
      @data_packet = data_packet(options, identifier)
      xml = PROCESS_SINGLE_CHECK.gsub("&&&DATA_PACKET&&&", @data_packet).gsub("&&&TERMINAL_ID&&&", @terminal_id)
      response = @client.call(:process_single_check, xml: xml)
      response = Hash.from_xml(response.body[:process_single_check_response][:process_single_check_result])
      {request: xml, response: response}
    end

    def process_single_certification_check options={}, terminal_id=nil, identifier='R'
      @terminal_id = terminal_id.to_s
      @data_packet = data_packet(options, identifier)
      xml = PROCESS_SINGLE_CERTIFICATION_CHECK.gsub("&&&DATA_PACKET&&&", @data_packet).gsub("&&&TERMINAL_ID&&&", @terminal_id)
      response = @certification_client.call(:process_single_certification_check, xml: xml)
      response = Hash.from_xml(response.body[:process_single_certification_check_response][:process_single_certification_check_result])
      {request: xml, response: response}
    end

    def process_single_certification_check_with_token options={}, terminal_id=nil, identifier='R'
      @terminal_id = terminal_id.to_s
      @data_packet = data_packet(options, identifier)
      xml = PROCESS_SINGLE_CERTIFICATION_CHECK.gsub("&&&DATA_PACKET&&&", @data_packet).gsub("&&&TERMINAL_ID&&&", @terminal_id)
      response = @certification_client.call(:process_single_certification_check, xml: xml)
      response = Hash.from_xml(response.body[:process_single_certification_check_response][:process_single_certification_check_result])
      {request: xml, response: response}
    end

    def get_archived_response request_id
      @terminal_id = terminal_id.to_s
      xml = GET_ARCHIVED_RESPONSE.gsub("&&&REQUEST_ID&&&", request_id).gsub("&&&TERMINAL_ID&&&", @terminal_id)
      response = @client.call(:get_archived_response, xml: xml)
      response = Hash.from_xml(response.body[:get_archived_response])
      {request: xml, response: response}
    end

    alias_method :archived, :get_archived_response
    alias_method :get_archived, :get_archived_response
    alias_method :archived_response, :get_archived_response

=begin
    def authorize options, terminal_id
      process_single_certification_check options, terminal_id, 'R'
    end

    def void
      process_single_certification_check options, terminal_id, 'V'
    end

    def reversal
      process_single_certification_check options, terminal_id, 'F'
    end
=end

    def data_packet options={}, identifier
      xml = <<xml
<AUTH_GATEWAY REQUEST_ID="#{options[:request_id]}">
<TRANSACTION>
<TRANSACTION_ID>#{options[:transaction_id]}</TRANSACTION_ID>
<MERCHANT>
<TERMINAL_ID>#{@terminal_id}</TERMINAL_ID>
</MERCHANT>
<PACKET>
<IDENTIFIER>#{identifier}</IDENTIFIER>
<ACCOUNT>
<ROUTING_NUMBER>#{options[:routing_number]}</ROUTING_NUMBER>
<ACCOUNT_NUMBER>#{options[:account_number]}</ACCOUNT_NUMBER>
#{check_number(options) if options[:check_number].present?}
<ACCOUNT_TYPE>#{options[:account_type]}</ACCOUNT_TYPE>
</ACCOUNT>
<CONSUMER>
#{consumer_info(options)}
<ADDRESS1>#{options[:address_1]}</ADDRESS1>
<ADDRESS2>#{options[:address_2]}</ADDRESS2>
<CITY>#{options[:city]}</CITY>
<STATE>#{options[:state]}</STATE>
<ZIP>#{options[:zip]}</ZIP>
<PHONE_NUMBER>#{options[:phone_number]}</PHONE_NUMBER>
<DL_STATE>#{options[:dl_state]}</DL_STATE>
<DL_NUMBER>#{options[:dl_number]}</DL_NUMBER>
<COURTESY_CARD_ID></COURTESY_CARD_ID>
#{identity_block options}
</CONSUMER>
<CHECK>
<CHECK_AMOUNT>#{options[:check_amount]}</CHECK_AMOUNT>
</CHECK>
</PACKET>
</TRANSACTION>
</AUTH_GATEWAY>
xml

      xml.gsub!("<", "&lt;").gsub!(">", "&gt;")
    end

    def identity_block options
      if ["12", "13", "16", "17"].include? @terminal_id[2..3]
        <<xml
<IDENTITY>
<DOB_YEAR>#{options[:dob_year]}</DOB_YEAR>
</IDENTITY>
xml
      end
    end

    def consumer_info options
      options[:company_name].present? ? corporate_consumer(options) : non_corporate_consumer(options)
    end

    def check_number options
      <<xml
<CHECK_NUMBER>#{options[:check_number]}</CHECK_NUMBER>
xml
    end

    def corporate_consumer options
      <<xml
<COMPANY_NAME>#{options[:company_name]}</COMPANY_NAME>
xml
    end

    def non_corporate_consumer options
      <<xml
<FIRST_NAME>#{options[:first_name]}</FIRST_NAME>
<LAST_NAME>#{options[:last_name]}</LAST_NAME>
xml
    end

  end
end