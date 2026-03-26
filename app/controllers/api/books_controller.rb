class Api::BooksController < ApplicationController

  def index
    #current_userに紐づく、論理削除されていないbookを降順で取得する
    #renderでクライアントにjson形式でbookのid,titile、authorを返す
  end
  
  def create
    #current_userに紐づくbookを生成する
    #生成する時にbook_paramsを使う
    #生成したbookを保存する
    #renderでクリアイアントに#renderでクライアントにjson形式でbookのid,titile、authorを返す
    #statusはcreated
  end

  def book_params
    #bookモデルからtitleとauthorを取得する
  end
end
