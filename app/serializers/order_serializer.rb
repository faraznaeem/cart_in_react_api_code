class OrderSerializer < ActiveModel::Serializer
  attributes :id, :products_1, :products_2, :products_3, :products, :total, :order_total, :finalized

  def products_1
    products = []
    object.order_items.group_by(&:product_id).each do |key, value|
      product = Product.find(key)
      hash = { amount: value.count, name: product.name, total: (product.price * value.count) }
      products.push hash
    end
    products
  end

  def products_2
    products = []
    unique_items = object.order_items.uniq(&:product)
    unique_items_count = object.order_items.group_by(&:product_id).map { |key, value| [key, value.size] }.to_h
    unique_items.each do |item|
      products.push(
        amount: unique_items_count[item.product_id],
        name: item.product.name,
        total: (unique_items_count[item.product_id] * item.product.price)
      )
    end
    products
  end

  def products_3
    object.order_items.group_by(&:product_id).map do |_key, value|
      product = value.uniq(&:product_id)[0].product
      { amount: value.size, name: product.name, total: (value.size * product.price) }
    end
	end
	alias_method :products, :products_3

  def total
    object.order_items.joins(:product).sum('products.price')
  end
end