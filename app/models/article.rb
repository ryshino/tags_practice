class Article < ApplicationRecord
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags, dependent: :destroy
  belongs_to :user

  def tags_save(tag_list)
    # すでにタグ付け登録していた場合、紐付いているタグをすべて削除
    if self.tags != nil
      article_tags_records = ArticleTag.where(article_id: self.id)
      article_tags_records.destroy_all
    end

    tag_list.each do |tag|
      # first_or_createメソッドは、whereと一緒に使うことで、
      # 既に値が保存されていればレコードを取得し、保存されていなければ新しくレコードを保存する
      inspected_tag = Tag.where(tag_name: tag).first_or_create
      self.tags << inspected_tag
    end
  end
end
