require 'digest'

class ApplicationController < ActionController::API

  def authenticate_user!
    # headerから,authorization,httpヘッダの情報を受け取る
    http = request.headers["Authorization"]
    # header = request.headers["Content-Type"]
    # 
    # 受け取ったauthorizatonヘッダの値を取り出す
    scheme, raw = http.split(" ", 2)

    # Bearer token形式の文字列をsplitする。splitした左側scheme,右側をraw として扱う
    # 
    # bearerスキームかどうかのチェックをする。ないなら401
    if scheme != "Bearer"
      # render text: "メールとパスワードが空です" and return 
      render json: { error: "NO Bearer" }, status: :unauthorized
    end
    # 
    # rawが取得できているか。ないなら401
    if raw.nil? || raw.empty?
      render json: { error: "raw empty" }, status: :unauthorized
    end
    #
    # 
    # rawをdigest化する
    digest = Digest::SHA256.hexdigest(raw)

    puts digest
    # 
    # 
    # activeなaccess_tokenだけに絞る
    # 
    # rawをdigestしたものとaccess_tokensテーブルのtoken_digestカラムと条件で検索をする
    # 
    # ないなら401エラー
    # 
    # rawをdigest化した値と一致するaccess_tokenが見つかったら、access_tokenと紐づくuserをcurrent_userにする
  end
end
