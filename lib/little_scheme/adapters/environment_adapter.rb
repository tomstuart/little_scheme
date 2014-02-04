require 'delegate'

module LittleScheme
  module Adapters
    class EnvironmentAdapter < SimpleDelegator
      def [](key)
        super key.to_sym
      end
    end
  end
end
