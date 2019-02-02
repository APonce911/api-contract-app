class Api::V1::DocumentsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: [ :index, :show, :webhook]
  before_action :set_document, only: [:show]

  def index
    @documents = policy_scope(Document)
  end

  def show
  end

  def create
    post_and_save('sign')
    post_and_save('joint_debtor')
    render :index, status: :created
  end

  def webhook
    # p '===========entrei webhook action=============================='
    # we received a post request at webhook endpoint
      if request.headers['Content-Type'] == 'application/json'
        # p '==============entrei no if====================================='
        data = JSON.parse(request.body.read)
      else
        # application/x-www-form-urlencoded
        data = params.as_json
      end
    # p "fimmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm fora do if"
      # webhook_response and return
      # render :nothing => true, :status => 204, content_type: 'application/json' and return
      # render plain: {}.to_json, :status => 204, content_type: 'application/json' and return
      return webhook_response
  end

  private

  def webhook_response
    # return head :ok
      render :webhook , :status => 204, content_type: 'application/json' and return
    # return render plain: {error: 'ta foda essa porr4'}.to_json, status: 200, content_type: 'application/json'
    # return render json: {}, status: 200, content_type: 'application/json'
  end

  def post_and_save(signature_type)
    url = "https://sandbox.clicksign.com/api/v1/documents?access_token=#{ENV['CLICKSIGN_KEY'].to_s}"
    body =   {
                "document": {
                  "path": "/" + params[:filename],
                  "content_base64": params[:base64],
                  "auto_close": true,
                  "locale": "pt-BR",
                  "signers": [
                    {
                      "email": params[:client_email],
                      "sign_as": signature_type,
                      "auths": [
                        "sms"
                      ],
                      "name": params[:client_name],
                      "documentation": "123.321.123-40",
                      "birthday": "1983-03-31",
                      "has_documentation": true,
                      "send_email": true,
                      "phone_number": params[:phone_number],
                      "message": "Olá, por favor assine o documento."

                    }
                  ]
                }
              }.to_json

    headers = {:Content_Type => "application/json", :Accept => "application/json"}
    response = RestClient.post(url, body, headers)
    response_parsed = JSON.parse(response.body)

    @document = Document.new(document_params)
    @document.status = "running"
    @document.key = response_parsed["document"]["key"]
    @document.user = current_user
    @document.signature_type = signature_type
    @document.json_response = response
    authorize @document

    if @document.save
    else
      render_error
    end
  end

  def document_params
    # params.require(:document).permit(:key, :filename, :status)
    params.require(:document).permit(:filename)
  end

  def set_document
    @document = Document.find(params[:id])
    authorize @document # For Pundit
  end

  def render_error
    render json: { errors: @document.errors.full_messages },
      status: :unprocessable_entity
  end

  def render_nothing
    # render status: 200, json: {}.to_json
    # render json: {},
    #   status: :created
    # render nothing: true, status: 204, content_type: 'application/json'
    # render json: {nothing:true}, status: 204
    # head :ok
    # render :nothing => true, :status => 204
    render json: {teste: "sucesso!!!"}, status: :ok
  end

end
