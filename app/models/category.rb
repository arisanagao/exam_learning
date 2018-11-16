# frozen_string_literal: true

# Category = 資格名
class Category < ApplicationRecord
  # has_many :texts

  validates :name,
            presence:   true,
            uniqueness: true,
            length:     { in: 2..40 }

  before_save :create_path_name, on: %i[create]

  # urlのpathに:idではなくわかりやすい名前で表示できるように新たにpath_nameを生成する
  def create_path_name
    self.path_name = name.split(/\W/).join('_').downcase
  end
end
