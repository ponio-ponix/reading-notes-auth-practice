require "digest"

class ApplicationController < ActionController::API
  def authenticate_user!
    # headerから,authorization,httpヘッダの情報を受け取る
    http = request.headers["Authorization"]
    # header = request.headers["Content-Type"]
    if http.nil? || http.empty?
      render json: { error: "http empty" }, status: :unauthorized and return
    end
    #
    # 受け取ったauthorizatonヘッダの値を取り出す
    scheme, raw = http.split(" ", 2)

    # Bearer token形式の文字列をsplitする。splitした左側scheme,右側をraw として扱う
    #
    # bearerスキームかどうかのチェックをする。ないなら401
    if scheme != "Bearer"
      # render text: "メールとパスワードが空です" and return
      render json: { error: "NO Bearer" }, status: :unauthorized and return
    end
    #
    # rawが取得できているか。ないなら401
    if raw.nil? || raw.empty?
      render json: { error: "raw empty" }, status: :unauthorized and return
    end
    #
    #
    # rawをdigest化する
    digest = Digest::SHA256.hexdigest(raw)
    #
    #
    # activeなaccess_tokenだけに絞る
    access_token = AccessToken.active
    #
    # rawをdigestしたものとaccess_tokensテーブルのtoken_digestカラムと条件で検索をする
    #
    @active_token = access_token.find_by(token_digest: digest)

    if @active_token == nil
      render json: { error: "保存されている中で照合できるものはありません" }, status: :unauthorized and return
    else
      @current_user = @active_token.user
    end

    #
    # ないなら401エラー
    #
    # rawをdigest化した値と一致するaccess_tokenが見つかったら、access_tokenと紐づくuserをcurrent_userにする
  end
end
