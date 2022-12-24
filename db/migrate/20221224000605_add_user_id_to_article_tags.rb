class AddUserIdToArticleTags < ActiveRecord::Migration[7.0]
  def change
    add_reference :article_tags, :user, null: false, foreign_key: true
  end
end
