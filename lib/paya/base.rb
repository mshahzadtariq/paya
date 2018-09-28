module Paya
  class Base

    def process_payment options, type=:ccd, guaranteed=true, debit_only=true, check_verification=false, identity_verification=false, dl_required=false
      type = type.to_s.capitalize
      sub_type = guaranteed ? 'Guaranteed' : 'NonGuaranteed'
      payment_type = debit_only ? 'DebitTransaction' : 'CreditDebitTransaction'

      handler = "Paya::#{type}::#{sub_type}::#{payment_type}".contantize
      handler.new options
      handler.process check_verification, identity_verification, dl_required
    end

    def process_single_check options={}, terminal_id=nil, identifier='R'
=begin
      @terminal_id = terminal_id.to_s
      @data_packet = data_packet(options, identifier)
      xml = Paya::PROCESS_SINGLE_CHECK.gsub("&&&DATA_PACKET&&&", @data_packet).gsub("&&&TERMINAL_ID&&&", @terminal_id).gsub("&&&USER_NAME&&&", Paya.user_name).gsub("&&&PASSWORD&&&", Paya.password)
      response = Paya.client.call(:process_single_certification_check, xml: xml)
      response_hash = Hash.from_xml(response.body[:process_single_certification_check_response][:process_single_check_result])
      {request: xml, response: response_hash}
=end
      process_single_certification_check options, terminal_id, identifier
    end

    def process_single_check_with_token
      @terminal_id = terminal_id.to_s
      @data_packet = data_packet(options, identifier)
      xml = Paya::PROCESS_SINGLE_CERTIFICATION_CHECK.gsub("&&&DATA_PACKET&&&", @data_packet).gsub("&&&TERMINAL_ID&&&", @terminal_id).gsub("&&&USER_NAME&&&", Paya.user_name).gsub("&&&PASSWORD&&&", Paya.password)
      response = Paya.client.call(:process_single_certification_check, xml: xml)
      response_hash = Hash.from_xml(response.body[:process_single_certification_check_response][:process_single_certification_check_result])
      {request: xml, response: response_hash}
    end

    def process_single_certification_check options={}, terminal_id=nil, identifier='R'
      @terminal_id = terminal_id.to_s
      @data_packet = data_packet(options, identifier)
      xml = Paya::PROCESS_SINGLE_CERTIFICATION_CHECK.gsub("&&&DATA_PACKET&&&", @data_packet).gsub("&&&TERMINAL_ID&&&", @terminal_id).gsub("&&&USER_NAME&&&", Paya.user_name).gsub("&&&PASSWORD&&&", Paya.password)
      response = Paya.client.call(:process_single_certification_check, xml: xml)
      response = Hash.from_xml(response.body[:process_single_certification_check_response][:process_single_certification_check_result])
      {request: xml, response: response}
    end

    def get_archived_response request_id
      @terminal_id = terminal_id.to_s
      xml = Paya::GET_ARCHIVED_RESPONSE.gsub("&&&REQUEST_ID&&&", request_id).gsub("&&&TERMINAL_ID&&&", @terminal_id).gsub("&&&USER_NAME&&&", Paya.user_name).gsub("&&&PASSWORD", Paya.password)
      response = Paya.client.call(:get_archived_response, xml: xml)
      response_hash = Hash.from_xml(response.body[:get_archived_response])
      {request: xml, response: response_hash}
    end

    alias_method :archived, :get_archived_response
    alias_method :get_archived, :get_archived_response
    alias_method :archived_response, :get_archived_response

    def data_packet options={}, identifier
      identifier = options[:identifier] if options[:identifier].present?
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