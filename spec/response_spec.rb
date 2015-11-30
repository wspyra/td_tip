require 'td_tip/models/parameters'
require 'td_tip/models/response'

describe TdTip::Models::Response do
  parameters = TdTip::Models::Parameters.new amount: '100 EUR', tip: 15

  json_1 = '{"amount_with_tip": "125","tip": "25"}'
  json_2 = '{"amount_with_tip": "125"}'

  result_1 = { amount_with_tip: '125' }

  before(:each) do
    @response = TdTip::Models::Response.new parameters
  end

  context 'request' do
    it 'should return response' do
      allow(@response.class).to receive(:post) { json_1 }

      expect(@response.send(:calculate_request)).to eq(json_1)
    end

    it 'should parse valid json' do
      allow(@response.class).to receive(:post) { json_2 }

      expect(@response.send :parse_and_symbolize_json).to eq(result_1)
    end

    it 'should handle exceptions' do
      allow(@response).to receive(:calculate_request) { fail 'Test' }

      expect(@response.send :parse_and_symbolize_json).to eq(error: 'Test')
    end
  end

  context 'model' do
    it 'should add exceptions to validations' do
      allow(@response).to receive(:calculate_request) { fail 'Test' }

      @response.get
      @response.valid?

      expect(@response.errors.keys).to include(:error)
    end

    it 'should return values from parsed json' do
      allow(@response).to receive(:parse_and_symbolize_json) { result_1 }

      @response.get

      expect(@response.amount_with_tip).to eq(result_1[:amount_with_tip])
    end

    it 'should return currency from parameters' do
      allow(@response).to receive(:parse_and_symbolize_json) { result_1 }

      @response.get

      expect(@response.currency).to eq(parameters.currency)
    end

    it 'should not allow tips lt 0' do
      @response.instance_variable_set(:@tip, -100)

      @response.valid?

      expect(@response.errors.keys).to include(:tip)
    end

    it 'should not allow amount with tip eq or lt 0' do
      @response.instance_variable_set(:@amount_with_tip, 0)

      @response.valid?

      expect(@response.errors.keys).to include(:amount_with_tip)
    end
  end
end
