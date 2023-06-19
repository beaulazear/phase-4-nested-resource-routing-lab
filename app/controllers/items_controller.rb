class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = User.find_by!(id: params[:user_id])
      userItems = user.items
    else
      userItems = Item.all
    end
    render json: userItems, include: :user
  end

  def show
    item = Item.find_by!(id: params[:id])
    render json: item
  end

  def create
    user = User.find_by!(id: params[:user_id])
    newItem = user.items.create(items_params)
    render json: newItem, status: :created
  end

  private

  def render_not_found_response
    render json: { error: "User not found" }, status: :not_found
  end

  def items_params
    params.permit(:name, :description, :price)
  end

end
