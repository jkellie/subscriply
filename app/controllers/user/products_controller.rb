class User::ProductsController < User::BaseController

  def index
    
  end

  def show
    product = Product.find(params[:id])
    @product_presenter = User::ProductPresenter.new(product: product, user: current_user)
  end
  
end