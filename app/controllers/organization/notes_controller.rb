class Organization::NotesController < Organization::BaseController
  before_action :authenticate_organizer!
  
  def create
    @note = Note.new(note_params)
    
    if @note.save
      flash[:notice] = 'Note saved'
      redirect_to organization_user_path(@note.user)
    end
  end

  private

  def note_params
    params.require(:note).permit(:description).merge(user_id: params[:user_id], organizer_id: current_organizer.id)
  end

end