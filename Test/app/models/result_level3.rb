class ResultLevel3 < ResultClass
  attr_accessor :orders

  def initialize(data_struc)
    @orders = []

    data_documents = data_struc.documents
    data_orders    = data_struc.orders
    promotions     = data_struc.promotions

    data_orders.each do |data_order|
      document         = find_item_by_id(data_order.document_id, data_documents)
      promotion_amount = promotion_amount(data_order.promotion_id, promotions, document.price)
      processed_price  = new_price_or_zero(document.price - promotion_amount)
      service_fee      = document.service_fee
      transfers        = get_transfers(promotion_amount, processed_price, service_fee)

      @orders << { id: data_order.id, price: processed_price, transfers: transfers }
    end 
  end

  private

  def get_transfers(promotion, price, service_fee)
    transfers = []
    transfers << Transfer.new('pay_in', 'client', 'order', price)
    transfers << Transfer.new('transfer', 'order', 'lawyer', price)
    transfers << Transfer.new('transfer', 'lawyer', 'captain', new_price_or_zero(service_fee - promotion))

    transfers
  end

  def promotion_amount(promotion_id, promotions, price)
    return 0 unless promotion_id

    promotion = find_item_by_id(promotion_id, promotions)
    new_price = is_percentage?(promotion) ? percentage_promotion_amount(price, promotion) :  fixed_promotion_amount(price, promotion)
  end

  def is_percentage?(promotion)
    promotion.reduction != 0 if promotion && promotion.reduction
  end

  def percentage_promotion_amount(price, promotion)
    price * promotion.reduction / 100 
  end

  def fixed_promotion_amount(price, promotion)
    promotion.reduction_fixe
  end

  def new_price_or_zero(new_price)
    new_price > 0 ? new_price : 0
  end
end

