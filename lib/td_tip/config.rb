# Main module for gem
module TdTip
  DEFAULT_TIP = 15
  AMOUNT_CURRENCY_REGEXP = /\A[ ]*([\d]*[\.,]?[\d]{1,2})[ ]*([\w]+)?[ ]*\z/

  WS_URL = 'https://calculate-tip-ws.herokuapp.com'
  WS_METHOD = '/calculate-tip'
  WS_TIMEOUT = 15
end
