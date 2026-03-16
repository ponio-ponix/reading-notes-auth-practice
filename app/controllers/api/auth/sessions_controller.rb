require 'digest'

class Api::Auth::SessionsController < ApplicationController
  def create
    # ここに擬似コード → 実コード寄りで書く
    #　emailとpasswordの空、かつuserがいるか、passwordは一致してるかの確認
    email = params[:email]
    password = params[:password]

    if email.empty? || password.empty?
      render text: "メールとパスワードが空です" and return 
    end

    user = User.find_by(email: email)

    if user.email != email || user.password_digest != password
      render text: "メールアドレスかパスワードが違います" and return 
    end



    #
    # 生のraw tokenを生成する
    raw = SecureRandom.hex(10)
    #
    # digestをdb側に保存をする
    digest = Digest::SHA256.digest(raw)
    digest = digest.hexdigest



    # 
    # 保存をする時、具体的には access tokenを使用する
    AccessToken.create!(
      token_digest: digest,
      expires_at: 1.month.from_now,
      revoked_at: Time.now
    )
    #
    # クライアントに返す
    render json: email

    #
  end
end