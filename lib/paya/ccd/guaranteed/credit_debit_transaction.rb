
module Paya
  module Ccd
    module Guaranteed

      class CreditDebitTransaction < Base
        attr_accessor :request_id, :transaction_id, :routing_number, :account_number, :account_type, :company_name, :address_1, :address_2, :city, :state, :dl_state, :dl_number, :dob_year, :zip, :phone_number, :check_amount , :identifier

        def initialize options={}
          @request_id = options[:request_id]
          @transaction_id = options[:transaction_id]
          @routing_number = options[:routing_number]
          @account_number = options[:account_number]
          @account_type = options[:account_type]
          @company_name = options[:company_name]
          @address_1 = options[:address_1]
          @address_2 = options[:address_2]
          @city = options[:city]
          @state = options[:state]
          @dl_state = options[:dl_state]
          @dl_number = options[:dl_number]
          @dob_year = options[:dob_year]
          @zip = options[:zip]
          @phone_number = options[:phone_number]
          @check_amount = options[:check_amount]
          @identifier = options[:identifier]
        end

        def process options={}, check_verification=false, identity_verification=false, dl_required=false

        end

        def check_no_verification_dl_optional options={}
          process_single_check options, 1910, 'R'
        end

        def check_no_verification_dl_required options={}
          process_single_check options, 1911, 'R'
        end

        def check_verification_identity_verification_dl_optional options={}
          process_single_check options, 1912, 'R'
        end

        def check_verification_identity_verification_dl_required options={}
          process_single_check options, 1913, 'R'
        end

        def check_verification_only_dl_optional options={}
          process_single_check options, 1914, 'R'
        end

        def check_verification_only_dl_required options={}
          process_single_check options, 1915, 'R'
        end

        def identity_verification_only_dl_optional options={}
          process_single_check options, 1916, 'R'
        end

        def identity_verification_only_dl_required options={}
          process_single_check options, 1917, 'R'
        end

      end


    end

  end
end