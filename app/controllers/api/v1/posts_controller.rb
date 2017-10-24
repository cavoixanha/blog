class Api::V1::PostsController < ActionController::API
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  respond_to :json

  # GET /posts
  # GET /posts.json
  def index
    # @posts = Post.all
    @posts =
        if params[:sort_asc].present?
          Post.sort_by_created_at_asc
        else
          Post.sort_by_created_at_desc
        end

    @posts = @posts.page(params[:page])
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @comments = @post.comments.includes(:user)
  end

  # GET /posts/new
  def new
    @post = Post.new
    authorize @post
  end

  # GET /posts/1/edit
  def edit
    authorize @post
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.json { render :show, status: :created, location: @post }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    authorize @post
    respond_to do |format|
      if @post.update(post_params)
        format.json { render :show, status: :ok, location: @post }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    authorize @post
    @post.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def search
    if params[:term]
      @posts = Post.search_full_text(params[:term])
    else
      @posts = Post.all
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params[:post][:user_id] = current_user.id
      params.require(:post).permit(:title, :description, :user_id)
    end
end
