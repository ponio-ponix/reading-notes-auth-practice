
class ApplicationController < ActionController::API

  def authenticate_user!
    # headerから情報を受け取る
    # 
    # 受け取ったheaderのスキーマとトークンをsplitする
    # 
    # bearerスキームかどうかのチェックをする。ないなら401
    # 
    # rawが取得できているか。ないなら401
    # 
    # rawをdigest化する
    # 
    # activeのaccess_tokenに絞り、digestしたものとdbにあるものを照合する
    # 
    # ないなら401エラー
    # 
    # digest化したものとdbで照合が取れたらcurrent_userにする
  end
end
