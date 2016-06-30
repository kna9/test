class ResultLevel6 < ResultClass
  attr_accessor :orders

  def initialize(data_struc)
    @orders = []

    data_documents       = data_struc.documents
    data_products        = data_struc.products  
    data_promotions      = data_struc.promotions
    data_services        = data_struc.services
    data_lawyer_services = data_struc.lawyer_services

    data_order_documents = data_struc.order_documents
    data_order_products  = data_struc.order_products
    data_order_services  = data_struc.order_services
    data_orders          = data_struc.orders

    data_orders.each do |data_order|
      documents = get_documents(data_order.id, data_order_documents, data_documents)
      products  = get_products(data_order.id, data_order_products, data_products)
      services  = get_services(data_order.id, data_order_services, data_services, data_lawyer_services)

      promotion = find_promotion_for_order(data_order.promotion_id, data_order.promotion_code, data_promotions)

      @orders << { 
        id:        data_order.id, 
        price:     get_total_price(promotion, documents, products, services),
        transfers: get_transfers
      }
    end 
  end

  private

  def get_transfers
    # FIXME : not yet implemented
  end

  def find_promotion_for_order(promotion_id, promotion_code, promotions)
    return find_item_by_id(promotion_id, promotions) if promotion_id
    return unless promotion_code

    promotions_for_code = promotions.select { |promotion| promotion.promotion_code == promotion_code }

    return promotions_for_code.first if promotions_for_code.any? 
  end

  def get_total_price(promotion, documents, products, services)
    promotion_amount = promotion_amount(documents, promotion)
    price = new_price_or_zero(documents.map(&:price).sum - promotion_amount) + products.map(&:price).sum

    return price + services.map(&:price).sum
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

