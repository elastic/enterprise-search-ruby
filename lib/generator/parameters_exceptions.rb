# frozen_string_literal: true

module Elastic
  module Generator
    # This module has the logic for parameter renaming like the friendlier
    # :to_date to the api's filters[date][to] and any parameter serializing
    # necessary such as date formatting.
    module ParametersExceptions
      PARAMETERS_MAPPING = {
        name: 'engineName',
        from_date: 'filters[date][from]',
        to_date: 'filters[date][to]'
      }.freeze

      DATE_PARAMS = [:from_date, :to_date].freeze

      EXCEPTIONAL_APIS = ['api_logs'].freeze

      def rename_exceptional_parameters
        return unless EXCEPTIONAL_APIS.include? @method_name

        response = []
        PARAMETERS_MAPPING.each do |param|
          next unless @params.map { |p| p['name'] }.include? param[0].to_s

          response << check_date_params(param[0])
          response << "arguments['#{param[1]}'] = arguments.delete(:#{param[0]})"
        end

        response.join("\n")
      end

      def check_date_params(param_name)
        return unless DATE_PARAMS.include?(param_name)

        "arguments[:#{param_name}] = date_to_rfc3339(arguments[:#{param_name}])"
      end
    end
  end
end
