class ResultLevel5 < ResultClass
  attr_accessor :orders

  def initialize(data_struc)
    @orders = []

    data_documents  = data_struc.documents
    data_products   = data_struc.products  
    data_promotions = data_struc.promotions

    data_order_documents = data_struc.order_documents
    data_order_products  = data_struc.order_products
    data_orders          = data_struc.orders

    data_orders.each do |data_order|
      documents = get_documents(data_order.id, data_order_documents, data_documents)
      products  = get_products(data_order.id, data_order_products, data_products)
      promotion = find_item_by_id(data_order.promotion_id, data_promotions)

      @orders << { 
        id:        data_order.id, 
        price:     get_total_price(promotion, documents, products),
        transfers: get_transfers(promotion, documents, products)
      }
    end 
  end

  private

  def get_transfers(promotion, documents, products)
    transfers = []
    transfers << Transfer.new('pay_in', 'client', 'order', get_total_price(promotion, documents, products))
    transfers << Transfer.new('transfer', 'order', 'lawyer', get_transfer_order_to_lawyer(promotion, documents, products))
    transfers << Transfer.new('transfer', 'lawyer', 'captain',get_transfer_lawyer_to_captain(promotion, documents, products))
    transfers << Transfer.new('transfer', 'order', 'captain',get_transfer_order_to_captain(promotion, documents, products))

    transfers
  end

  def get_transfer_order_to_lawyer(promotion, documents, products)
    lawyer_documents = documents.select {|doc| doc.payment_direction == 'lawyer' }
    lawyer_products  = products.select {|prod| prod.payment_direction == 'lawyer' }

    new_price_or_zero(lawyer_documents.map(&:price).sum - promotion_amount(documents, promotion)) + lawyer_products.map(&:price).sum
  end

  def get_transfer_lawyer_to_captain(promotion, documents, products)
    lawyer_documents = documents.select {|doc| doc.payment_direction == 'lawyer' }
    lawyer_products  = products.select {|prod| prod.payment_direction == 'lawyer' }

    new_price_or_zero(lawyer_documents.map(&:service_fee).sum - promotion_amount(documents, promotion)) + lawyer_products.map(&:service_fee).sum
  end

  def get_transfer_order_to_captain(promotion, documents, products)
    captain_documents = documents.select {|doc| doc.payment_direction == 'captain' }
    products.map(&:service_fee).sum + captain_documents.map(&:service_fee).sum
  end

  def get_total_price(promotion, documents, products)
    promotion_amount = promotion_amount(documents, promotion)
    new_price_or_zero(documents.map(&:price).sum - promotion_amount) + products.map(&:price).sum
  end

  def promotion_amount(documents, promotion)
    return 0 unless promotion 

    document_price = documents.map(&:price).sum
    is_percentage?(promotion) ? percentage_promotion_amount(document_price, promotion) :  fixed_promotion_amount(document_price, promotion)
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

