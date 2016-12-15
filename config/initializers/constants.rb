# global taxe rate in percent
require 'bigdecimal'

# expressed in percent : 20 means 20%
TAX_RATE = BigDecimal.new('20')

# expressed in percent : 20 means 20%, includes the VAT
COMMISSION_RATE = BigDecimal.new('20')

# expressed in cents : 30 means 30c, includes the VAT
TRANSACTION_COST = BigDecimal.new('40')

PAGINATE_PAGES = Rails.env.development? ? '2' : '12'
