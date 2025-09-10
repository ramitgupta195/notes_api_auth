class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: [ :show, :update, :destroy ]
  before_action :ensure_active_user
  def index
    if current_user.admin?
      notes = Note.includes(:user).all
      render json: notes.as_json(include: { user: { only: [ :id, :email, :role ] } })
    else
      render json: current_user.notes
    end
  end

  def show
    render json: @note.as_json(include: { user: { only: [ :id, :email, :role ] } })
  end

  def create
    note = current_user.notes.new(note_params)
    if note.save
      render json: note, status: :created
    else
      render json: { errors: note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @note.update(note_params)
      render json: @note
    else
      render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy
    render json: { message: "Note deleted successfully." }, status: :ok
  end

  private

  def set_note
    @note = current_user.admin? ? Note.find(params[:id]) : current_user.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end

  private

  def ensure_active_user
    render json: { error: "Account deactivated" }, status: :forbidden unless current_user.active?
  end
end
