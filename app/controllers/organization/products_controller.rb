class Organization::ProductsController < Organization::BaseController
  before_action :find_product, only: [:edit, :show, :update, :destroy]
  respond_to :html, :json

  def index
    @products = current_organization.products.order('created_at ASC')
  end

  def edit
  end

  def new
    @product = Product.new
  end

  def show
    respond_to do |format|
      format.json do
        respond_with @product
      end
    end
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      flash[:info] = 'Product created'
      redirect_to organization_products_path
    else
      flash.now[:danger] = 'Error Creating Product'
      render 'new'
    end
  end

  def update
    if @product.update(product_params)
      flash[:info] = 'Product updated'
      redirect_to organization_products_path
    else
      flash.now[:danger] = 'Error Updating Product'
      render 'edit'
    end
  end

  def destroy
    if @product.destroy
      flash[:info] = 'Product Destroyed'
    else
      flash[:danger] = 'Error Destroying Product'
    end

    redirect_to organization_products_path
  end

  private

  def find_product
    @product = current_organization.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :image, :prepend_code, :description).merge(organization_id: current_organization.id)
  end

end