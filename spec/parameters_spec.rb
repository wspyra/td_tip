require 'td_tip/models/parameters'

describe TdTip::Models::Parameters do
  amount_1 = 100
  amount_2 = 100.34

  currency_1 = 'JPY'

  tip_1 = 20
  tip_2 = 200
  tip_3 = 0
  tip_4 = 'test'

  context 'amount parameter without currency' do
    valid_options_1 = { amount: amount_1.to_s }
    valid_options_2 = { amount: amount_2.to_s }
    valid_options_3 = { amount: amount_2.to_s.sub('.', ',') }
    valid_options_4 = { amount: "  #{amount_2}  " }

    it 'should parse amount without fraction' do
      parameters = TdTip::Models::Parameters.new valid_options_1

      expect(parameters.amount).to eq(amount_1)
    end

    it 'should parse amount with fraction after "."' do
      parameters = TdTip::Models::Parameters.new valid_options_2

      expect(parameters.amount).to eq(amount_2)
    end

    it 'should parse amount with fraction after ","' do
      parameters = TdTip::Models::Parameters.new valid_options_3

      expect(parameters.amount).to eq(amount_2)
    end

    it 'should parse amount with spaces' do
      parameters = TdTip::Models::Parameters.new valid_options_4

      expect(parameters.amount).to eq(amount_2)
    end
  end

  context 'amount parameter with currency' do
    valid_options_1 = { amount: "#{amount_2} #{currency_1}" }
    valid_options_2 = { amount: "   #{amount_2}    #{currency_1}   " }
    valid_options_3 = { amount: "#{amount_2}#{currency_1}" }

    it 'should parse amount with one space' do
      parameters = TdTip::Models::Parameters.new valid_options_1

      expect(parameters.amount).to eq(amount_2)
    end

    it 'should parse currency with one space' do
      parameters = TdTip::Models::Parameters.new valid_options_1

      expect(parameters.currency).to eq(currency_1)
    end

    it 'should parse amount with many spaces' do
      parameters = TdTip::Models::Parameters.new valid_options_2

      expect(parameters.amount).to eq(amount_2)
    end

    it 'should parse currency with many spaces' do
      parameters = TdTip::Models::Parameters.new valid_options_2

      expect(parameters.currency).to eq(currency_1)
    end

    it 'should parse amount with on spaces' do
      parameters = TdTip::Models::Parameters.new valid_options_3

      expect(parameters.amount).to eq(amount_2)
    end

    it 'should parse currency with on spaces' do
      parameters = TdTip::Models::Parameters.new valid_options_3

      expect(parameters.currency).to eq(currency_1)
    end
  end

  context 'amount is invalid' do
    options_1 = { amount: 'test' }
    options_2 = { amount: '0' }
    options_3 = { amount: '' }
    options_4 = { amount: '0 PLN' }
    options_5 = { amount: '-100' }
    options_6 = { amount: "#{amount_1}." }

    it 'should not parse amount without number at the beginning' do
      parameters = TdTip::Models::Parameters.new options_1

      parameters.valid?

      expect(parameters.errors.keys).to include(:amount)
    end

    it 'should not parse amount eq to 0' do
      parameters = TdTip::Models::Parameters.new options_2

      parameters.valid?

      expect(parameters.errors.keys).to include(:amount)
    end

    it 'should not parse empty string' do
      parameters = TdTip::Models::Parameters.new options_3

      parameters.valid?

      expect(parameters.errors.keys).to include(:amount)
    end

    it 'should not parse amount eq to 0 and currency' do
      parameters = TdTip::Models::Parameters.new options_4

      parameters.valid?

      expect(parameters.errors.keys).to include(:amount)
    end

    it 'should not parse amount lt 0' do
      parameters = TdTip::Models::Parameters.new options_5

      parameters.valid?

      expect(parameters.errors.keys).to include(:amount)
    end

    it 'should not parse amount with "." and no fraction' do
      parameters = TdTip::Models::Parameters.new options_6

      parameters.valid?

      expect(parameters.errors.keys).to include(:amount)
    end
  end

  context 'tip' do
    options_1 = { amount: '100' }
    options_2 = { amount: '100', tip: tip_1 }
    options_3 = { amount: '100', tip: tip_2 }
    options_4 = { amount: '100', tip: tip_3 }
    options_5 = { amount: '100', tip: tip_4 }

    it 'should use default tip' do
      parameters = TdTip::Models::Parameters.new options_1

      parameters.valid?

      expect(parameters.tip).to eq(TdTip::DEFAULT_TIP)
    end

    it 'should allow valid tip value' do
      parameters = TdTip::Models::Parameters.new options_2

      parameters.valid?

      expect(parameters.errors.keys).not_to include(:tip)
    end

    it 'should allow tips over 100%' do
      parameters = TdTip::Models::Parameters.new options_3

      parameters.valid?

      expect(parameters.errors.keys).not_to include(:tip)
    end

    it 'should allow tips eq to 0' do
      parameters = TdTip::Models::Parameters.new options_4

      parameters.valid?

      expect(parameters.errors.keys).not_to include(:tip)
    end

    it 'should not allow tips as string' do
      parameters = TdTip::Models::Parameters.new options_5

      parameters.valid?

      expect(parameters.errors.keys).to include(:tip)
    end
  end

  context 'to_params' do
    options_1 = { amount: amount_2.to_s, tip: tip_1 }
    return_1 = { amount: amount_2, tip: tip_1 }

    it 'should return valid hash' do
      parameters = TdTip::Models::Parameters.new options_1

      expect(parameters.to_params).to eq(return_1)
    end
  end
end
