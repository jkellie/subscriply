class Organization::LocationsController < Organization::BaseController

  def create
    location = Location.new(location_params)

    respond_to do |format|
      if location.save
        format.js { render 'update_locations' }
      else
        format.json do
          render json: { error: location.errors.full_messages.join(', ') }, status: 422
        end
      end
    end
  end

  def update
    location = Location.find(params[:id])

    respond_to do |format|
      if location.update(location_params)
        format.js { render 'update_locations' }
      else
        format.json do
          render json: { error: 'Error message' }, status: 422
        end
      end
    end
  end

  def destroy
    location = Location.find(params[:id])

    respond_to do |format|
      if location.destroy
        format.js { render 'update_locations' }
      else
        format.json do
          render json: { error: 'Error message' }, status: 422
        end
      end
    end
  end

  private

  def location_params
    params.require(:location).permit(:name, :street_address, :street_address_2, 
      :city, :state, :zip).merge(organization_id: current_organization.id)
  end
end