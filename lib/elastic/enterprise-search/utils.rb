# frozen_string_literal: true

module Elastic
  module WorkplaceSearch
    # Util functions
    module Utils
      module_function

      def stringify_keys(hash)
        output = {}
        hash.each do |key, value|
          output[key.to_s] = value
        end
        output
      end
    end
  end
end
