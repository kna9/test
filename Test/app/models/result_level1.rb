class ResultLevel1 < ResultClass
  attr_accessor :orders

  def initialize(data_struc)
    @orders = []

    data_documents = data_struc.documents
    data_orders    = data_struc.orders

    data_orders.each do |data_order|
      document = find_item_by_id(data_order.document_id, data_documents)
      @orders << { id: data_order.id, price: document.price }
    end 
  end
end

