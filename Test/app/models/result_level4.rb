class ResultLevel4 < ResultClass
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

      documents_price_sum       = documents.map(&:price).sum
      documents_service_fee_sum = documents.map(&:service_fee).sum
      products_price_sum        = products.map(&:price).sum
      products_service_fee_sum  = products.map(&:service_fee).sum

      promotion_amount = promotion_amount(data_order.promotion_id, data_promotions, documents_price_sum)

      document_service_fee = documents_service_fee_sum

      @orders << { 
        id: data_order.id, 
        price: get_total_price(promotion_amount, documents_price_sum, products_service_fee_sum), 
        transfers: get_transfers(
          promotion_amount, 
          documents_price_sum,
          document_service_fee, 
          products_service_fee_sum
        )
      }
    end 
  end

  private

  def get_total_price(promotion, document_price, product_service_fee)
    new_price_or_zero(document_price - promotion) + product_service_fee
  end

  def get_transfers(promotion, document_price, document_service_fee, product_service_fee)
    transfers = []

    pay_in_client = get_total_price(promotion, document_price, product_service_fee)
    transfer_order_lawyer = new_price_or_zero(document_price - promotion)
    transfer_lawyer_captain = new_price_or_zero(document_service_fee - promotion)
    transfer_order_captain = product_service_fee


    transfers << Transfer.new('pay_in', 'client', 'order', pay_in_client)
    transfers << Transfer.new('transfer', 'order', 'lawyer', transfer_order_lawyer)
    transfers << Transfer.new('transfer', 'lawyer', 'captain',transfer_lawyer_captain)
    transfers << Transfer.new('transfer', 'order', 'captain',transfer_order_captain)

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

