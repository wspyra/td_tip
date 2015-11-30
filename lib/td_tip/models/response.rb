require 'httparty'

module TdTip
  module Models
    # Response
    class Response
      include ActiveModel::Validations
      include HTTParty

      base_uri TdTip::WS_URL

      attr_accessor :parameters
      attr_reader :amount_with_tip, :tip, :currency, :error

      validates_presence_of :amount_with_tip, :tip
      validates_numericality_of :tip, greater_than_or_equal_to: 0
      validates_numericality_of :amount_with_tip, greater_than: 0
      validate :other_errors

      def initialize(parameters)
        @parameters = parameters
      end

      def get
        result = parse_and_symbolize_json
        @amount_with_tip = result[:amount_with_tip]
        @tip = result[:tip]
        @error = result[:error]
        @currency = parameters.currency
        self
      end

      private

      def other_errors
        errors.add(:error, error) unless error.blank?
      end

      def parse_and_symbolize_json
        with_error_handling { JSON.parse(calculate_request.body).symbolize_keys! }
      end

      def calculate_request
        self.class.post WS_METHOD,
                        query: parameters.to_params,
                        timeout: WS_TIMEOUT
      end

      def with_error_handling
        yield
      rescue => e
        { error: e.message }
      end
    end
  end
end
