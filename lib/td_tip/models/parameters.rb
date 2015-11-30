require 'active_model'

module TdTip
  module Models
    # Storing and processing parameters
    class Parameters
      include ActiveModel::Validations

      attr_reader :tip, :currency, :amount

      validates_presence_of :amount, :tip
      validates_numericality_of :tip,    greater_than_or_equal_to: 0
      validates_numericality_of :amount, greater_than: 0

      def initialize(options = {})
        @tip = options[:tip].blank? ? DEFAULT_TIP : options[:tip]
        parse_amount options[:amount]
      end

      def to_params
        { amount: amount, tip: tip }
      end

      protected

      def parse_amount(amount_raw)
        matches = TdTip::AMOUNT_CURRENCY_REGEXP.match amount_raw
        return unless matches
        @amount = matches.captures[0].sub(',', '.').to_f
        @currency = matches.captures[1].to_s
      end
    end
  end
end
