class Api::OrdersController < ApplicationController
  def create
    order = Order.create
    order.order_items.create(product_id: params[:product_id])
    render json: { message: "The product has been added to your order", order_id: order.id }
  end
end
