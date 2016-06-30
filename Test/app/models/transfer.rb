class Transfer
  attr_accessor :type, :from, :to, :amount

  def initialize(type, from, to, amount)
  	@type   = type
  	@from   = from
  	@to     = to
  	@amount = amount
  end
end