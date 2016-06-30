class ResultClass
  # FIXME: refactor common code

  private 

  def find_item_by_id(id, items)
    selected_item = items.select { |item| item.id == id }

    return nil unless selected_item.any?

    return selected_item.first
  end

  def find_items_by_order_id(order_id, items)
    items.select { |item| item.order_id == order_id }
  end

  def get_documents(data_order_id, order_documents, data_documents)
    found_documents = []

    find_items_by_order_id(data_order_id, order_documents).each do |order_document|

      if docu = find_item_by_id(order_document.document_id, data_documents)
        found_documents << OpenStruct.new(
          price: docu.price, 
          service_fee: docu.service_fee,
          payment_direction: docu.payment_direction)
      end
    end

    found_documents
  end

  def get_products(data_order_id, order_products, data_products)
    found_products = []

    find_items_by_order_id(data_order_id, order_products).each do |order_product|

      if prod = find_item_by_id(order_product.product_id, data_products)
        found_products << OpenStruct.new(
          price: prod.price, 
          service_fee: prod.service_fee,
          payment_direction: prod.payment_direction)
      end
    end

    found_products
  end

  def get_services(data_order_id, order_services, data_services, data_lawyer_services)
    # FIXME : LEVEL6 code to refactor
    found_services = []

    find_items_by_order_id(data_order_id, order_services).each do |order_service|

      found_service = if order_service.lawyer_id
        lawer_services = data_lawyer_services.select { |item| item.lawyer_id == order_service.lawyer_id }
        selected_lawyer_services = lawer_services.select { |item| item.service_id == order_service.service_id }
        
        selected_lawyer_services.first if selected_lawyer_services
      else
        find_item_by_id(order_service.service_id, data_services)
      end

      found_services << OpenStruct.new(
        price: found_service.price, 
        service_fee: found_service.service_fee, 
        payment_direction: found_service.payment_direction) if found_service
    end

    found_services
  end
end