class Api::V1::DocumentsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  before_action :set_document, only: [:show]

  def index
    @documents = policy_scope(document)
  end

  def show
  end

  def create
    @document = Document.new(document_params)
    @document.user = current_user
    authorize @document

    if @document.save
      render :show, status: :created
    else
      render_error
    end
  end

  private

  def document_params
    params.require(:document).permit(:key, :filename, :status)
  end

  def set_document
    @document = Document.find(params[:id])
    authorize @document # For Pundit
  end

  def render_error
    render json: { errors: @document.errors.full_messages },
      status: :unprocessable_entity
  end

end
