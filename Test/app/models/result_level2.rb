class ResultLevel2 < ResultClass
  attr_accessor :orders

  def initialize(data_struc)
    @orders = []

    data_documents = data_struc.documents
    data_orders    = data_struc.orders
    promotions     = data_struc.promotions

    data_orders.each do |data_order|
      document        = find_item_by_id(data_order.document_id, data_documents)
      processed_price = apply_promotion(data_order.promotion_id, promotions, document.price)

      @orders << { id: data_order.id, price: processed_price }
    end 
  end

  private

  def apply_promotion(promotion_id, promotions, price)
    return price unless promotion_id

    promotion = find_item_by_id(promotion_id, promotions)
    new_price = is_percentage?(promotion) ? process_percentage_promotion(price, promotion) :  process_fixed_promotion(price, promotion)
  end

  def is_percentage?(promotion)
    promotion.reduction != 0 if promotion && promotion.reduction
  end

  def process_percentage_promotion(price, promotion)
    new_price_or_zero(price - (price * promotion.reduction / 100))  
  end

  def process_fixed_promotion(price, promotion)
    new_price_or_zero(price - promotion.reduction_fixe)
  end

  def new_price_or_zero(new_price)
    new_price > 0 ? new_price : 0
  end
end

