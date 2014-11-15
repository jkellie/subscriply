class User::ProductsController < User::BaseController

  def index
    
  end

  def show
    @product = Product.find params[:id]
  end
  
end