class Api::NotesController < ApplicationController
  before_action :set_book, only: [ :create ]

  def create
    # bookに紐づくnoteオブジェクトを生成する
    # 生成する時にnote_paramsを使う
  end

  def destroy
    # note.find(params[:id]はidが合えばnoteを直接取得できる)
    # current_userのnoteが確認していないため、owner-scopeが弱い
    # そのため、他人のnoteに触れる余地がある
  end

  def set_book
    # current_userに紐づく論理削除されていないかつ特定のbook_idのbookを@bookに入れる
  end

  def note_params
    # noteモデルのpage、quote,memoの情報を取得する
  end
end
