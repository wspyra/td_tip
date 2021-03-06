require 'thor'
require 'td_tip/cli'

describe TdTip::Cli do
  input_1 = 'user input'

  amount_1 = '100'
  amount_2 = '-100'

  tip_1 = 20

  error_1 = 'test'

  before(:each) do
    @cli = TdTip::Cli.new
    allow(@cli).to receive(:ask) { input_1 }
  end

  context 'options from command line' do
    before(:each) do
      @cli.send(:options=, amount: amount_1, tip: tip_1)
    end

    it 'should use amount from command line' do
      @cli.send :set_cli_options

      expect(@cli.cli_options[:amount]).to eq(amount_1)
    end

    it 'should use tip from command line' do
      @cli.send :set_cli_options

      expect(@cli.cli_options[:tip]).to eq(tip_1)
    end
  end

  context 'input from user' do
    it 'should ask for amount when no parameter' do
      @cli.send :set_cli_options

      expect(@cli.cli_options[:amount]).to eq(input_1)
    end

    it 'should ask for tip when no parameter' do
      @cli.send :set_cli_options

      expect(@cli.cli_options[:tip]).to eq(input_1)
    end
  end

  context 'parameters' do
    it 'should set parameters from options' do
      @cli.send(:options=, amount: amount_1, tip: tip_1)
      @cli.send :set_cli_options
      @cli.send :set_parameters

      expect(@cli.parameters).to be_instance_of TdTip::Models::Parameters
    end
  end

  context 'calculation' do
    it 'should display parameters validation errors' do
      @cli.send(:options=, amount: amount_2, tip: tip_1)

      allow(@cli).to receive(:display_validation_errors) { error_1 }

      expect(@cli.calculate).to eq(error_1)
    end

    it 'should has a response' do
      @cli.send(:options=, amount: amount_1, tip: tip_1)
      resp = double(TdTip::Models::Response,
                    amount_with_tip: amount_1,
                    tip: tip_1,
                    currency: 'EUR')
      allow(resp).to receive(:get) { resp }
      allow(resp).to receive(:valid?) { true }
      allow(TdTip::Models::Response).to receive(:new) { resp }
      allow(@cli).to receive(:say) {}

      @cli.calculate

      expect(@cli.response).not_to be_nil
    end

    it 'should handle invalid response' do
      @cli.send(:options=, amount: amount_1, tip: tip_1)
      resp = double(TdTip::Models::Response,
                    amount_with_tip: amount_1,
                    tip: tip_1,
                    currency: 'EUR')
      allow(resp).to receive(:valid?) { false }
      allow(@cli).to receive(:display_validation_errors) { 'test' }
      allow(@cli).to receive(:say) {}
      allow(@cli).to receive(:response) { resp }

      out = @cli.send :display_response

      expect(out).not_to be_nil
    end

    it 'should display validation errors' do
      parameters = TdTip::Models::Parameters.new amount: amount_2, tip: tip_1
      allow(@cli).to receive(:say) { 'test' }

      parameters.valid?
      out = @cli.send :display_validation_errors, parameters

      expect(out.to_s).to match('amount')
    end
  end
end
