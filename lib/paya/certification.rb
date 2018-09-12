module Paya
  module Certification

    class << self
      def request
        response = {}
        ppd_certification = Paya::Certification::Ppd.new
        response[:ppd] = ppd_certification.script

        ccd_certification = Paya::Certification::Ccd.new
        response[:ccd] = ccd_certification.script

        web_certification = Paya::Certification::Web.new
        response[:web] = web_certification.script

        tel_certification = Paya::Certification::Tel.new
        response[:tel] = tel_certification.script
        response
      end
    end
  end
end