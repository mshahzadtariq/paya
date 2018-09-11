module LocalHires
  module Paya
    module Certification
      class Ppd < Base

        TERMINAL_IDS = [1810, 1811, 1814, 1815, 1812, 1813, 1817, 1816]

        def initialize
          #ToDo
        end

        def script
          log = []
          TERMINAL_IDS.each do |terminal_id|
            AMOUNTS.each_with_index do |amount, index|
              identifier = IDENTIFIERS[index]
              options = build_options amount, ROUTING_NUMBERS[index], identifier
              paya = LocalHires::Paya::Ppd.new
              log << paya.process_single_certification_check(options, terminal_id, identifier)

            end
          end
          log
        end

        def build_options amount, routing_number, identifier
          {
              request_id: '4654',
              transaction_id: '0a4f529d-70fd-4ddb-b909-b5598dc07579',
              routing_number: routing_number,
              account_number: '24413815',
              account_type: 'Checking',
              first_name: 'Test',
              last_name: 'Name',
              address_1: '1001 Test Drive',
              address_2: '#200',
              city: 'Destin',
              state: 'FL',
              dl_state: 'FL',
              dl_number: 'D12346544',
              dob_year: 1951,
              zip: '32540',
              phone_number: '8001231456',
              check_amount: amount,
              identifier: identifier
          }
        end
      end
    end
  end
end