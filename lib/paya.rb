require "paya/version"

module Paya
  # Your code goes here...
  class << self
    def config
      yield(self)
    end
  end
end

require 'paya/base'
