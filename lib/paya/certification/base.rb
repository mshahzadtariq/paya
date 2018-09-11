module LocalHires
  module Paya
    module Certification
      class Base

        ROUTING_NUMBERS = [490000018, 490000018, 490000034, 490000018, 490000018]
        AMOUNTS = [1.50, -10.50, 1.84, 16.79, 1.50]
        IDENTIFIERS = {0 => 'R', 1 => 'R', 2 => 'R', 3 => 'V', 4 => 'F'}

        def initialize
          response = {}
          ppd_certification = Ppd.new
          response[:ppd] = ppd_certification.script

          ccd_certification = Ccd.new
          response[:ccd] = ccd_certification.script

          web_certification = Web.new
          response[:web] = web_certification.script

          tel_certification = Tel.new
          response[:paya] = tel_certification.script

          binding.pry
        end

      end
    end
  end
end