require('set')

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  # GET /articles or /articles.json
  def index
    @articles = Article.all
    
    # OR検索
    # if params[:tag_ids]
    #   @articles = []
    #   params[:tag_ids].each do |key, value|
    #   # 選択したタグのvalueは1になる。if文で1のタグだけを検索して代入をする 
    #     @articles += Tag.find_by(tag_name: key).articles if value == "1"
    #   end
    #   # 複数のタグ付けができるので、同じ投稿はuniq!!で重複を取り除いている
    #   @articles.uniq!
    # end

    # AND検索
    if params[:tag_ids]
      @articles = Set.new([])
      params[:tag_ids].each do |key, value|
        if value == "1"
          # タグに紐づく投稿を代入
          tag_articles = Tag.find_by(tag_name: key).articles
          @tag_articles = Set.new(tag_articles)
          # @articlesが空の場合、tag_articlesを代入
          # 空でない場合、@articlesとtag_articlesの値を代入する
          @articles = @articles.empty? ? @tag_articles : @articles & @tag_articles
        end
      end
    end

    if params[:tag_name]
      Tag.create(tag_name: params[:tag_name])
    end
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)
    # tag_list = params[:article][:tag_names].split(",") #追加
    # @article.tags_save(tag_list) #追加

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content, tag_ids: [])
    end
end
