module Jem
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      desc "Creates Paya initializer for your application"

      def copy_initializer
        template "paya_initializer.rb", "config/initializers/paya.rb"

        puts "Install complete! Truly Outrageous!"
      end
    end
  end
end