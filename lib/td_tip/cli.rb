module TdTip
  # Command line interface
  class Cli < Thor
    default_task :calculate

    desc 'calculate', 'Calculate tip amount'
    long_desc '`calculate` will print out total amount and tip value itself.'

    method_options amount: :string,
                   tip: :numeric

    attr_reader :cli_options, :parameters, :response

    # Main/default action
    def calculate
      set_cli_options
      set_parameters

      if parameters.valid?
        set_response
        display_response
      else
        display_validation_errors parameters
      end
    end

    private

    # Set options from command line or ask user
    def set_cli_options
      @cli_options = options.dup
      @cli_options[:amount] ||= ask('# Please provide amount:')
      @cli_options[:tip] ||= ask('# Please provide tip (%):')
    end

    # Set parameters from options
    def set_parameters
      @parameters = TdTip::Models::Parameters.new cli_options
    end

    # Set response using parameters
    def set_response
      @response = TdTip::Models::Response.new(parameters).get
    end

    # Print response on screen
    def display_response
      if response.valid?
        say "# Total amount with tip: #{response.amount_with_tip}" \
            " #{response.currency}\n"
        say "# Tip amount: #{response.tip} #{response.currency}\n"
      else
        display_validation_errors response
      end
    end

    # Print validation messages
    def display_validation_errors(obj)
      obj.errors.messages.each do |field, messages|
        say "# #{field.capitalize}: #{messages.join ', '}\n"
      end
    end
  end
end
