module Paya
  module Ppd
    module NonGuaranteed
      class CreditDebitTransaction < Base
        attr_accessor :request_id, :transaction_id, :routing_number, :account_number, :account_type, :company_name, :address_1, :address_2, :city, :state, :dl_state, :dl_number, :dob_year, :zip, :phone_number, :check_amount , :identifier

        def initialize options={}
          @options = options
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

        def process check_verification=false, identity_verification=false, dl_required=false
          if check_verification == false and identity_verification == false and dl_required == false
            check_no_verification_dl_optional
          elsif check_verification == false and identity_verification == false and dl_required == true
            check_no_verification_dl_required
          elsif check_verification == true and identity_verification == true and dl_required == false
            check_verification_identity_verification_dl_optional
          elsif check_verification == true and identity_verification == true and dl_required == true
            check_verification_identity_verification_dl_required
          elsif check_verification == true and identity_verification == false and dl_required == false
            check_verification_only_dl_optional
          elsif check_verification == true and identity_verification == false and dl_required == true
            check_verification_only_dl_required
          elsif check_verification == false and identity_verification == true and dl_required == false
            identity_verification_only_dl_optional
          elsif check_verification == false and identity_verification == true and dl_required == true
            identity_verification_only_dl_required
          else
            raise "Transaction not supported"
          end
        end

        def check_no_verification_dl_optional
          process_single_check @options, Paya.configuration.ppd_non_guaranteed_credit_debit_check_no_verification_dl_optional_terminal_id, 'R'
        end

        def check_no_verification_dl_required
          process_single_check @options, Paya.configuration.ppd_non_guaranteed_credit_debit_check_no_verification_dl_required_terminal_id, 'R'
        end

        def check_verification_identity_verification_dl_optional
          process_single_check @options, Paya.configuration.ppd_non_guaranteed_credit_debit_check_verification_identity_verification_dl_optional_terminal_id, 'R'
        end

        def check_verification_identity_verification_dl_required
          process_single_check @options, Paya.configuration.ppd_non_guaranteed_credit_debit_check_verification_identity_verification_dl_required_terminal_id, 'R'
        end

        def check_verification_only_dl_optional
          process_single_check @options, Paya.configuration.ppd_non_guaranteed_credit_debit_check_verification_only_dl_optional_terminal_id, 'R'
        end

        def check_verification_only_dl_required
          process_single_check @options, Paya.configuration.ppd_non_guaranteed_credit_debit_check_verification_only_dl_required_terminal_id, 'R'
        end

        def identity_verification_only_dl_optional
          process_single_check @options, Paya.configuration.ppd_non_guaranteed_credit_debit_identity_verification_only_dl_optional_terminal_id, 'R'
        end

        def identity_verification_only_dl_required
          process_single_check @options, Paya.configuration.ppd_non_guaranteed_credit_debit_identity_verification_only_dl_required_terminal_id, 'R'
        end

      end
    end
  end
end
