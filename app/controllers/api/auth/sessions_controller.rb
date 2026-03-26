require "digest"

class Api::Auth::SessionsController < ApplicationController
  before_action :authenticate_user!, only: [ :destroy ]

  # このアクションはログイン後のトークンを生成する関数である
  def create
    # ①入力を受ける
    # 入力
    email = params[:email]
    password = params[:password]

    # ②メールかパスワードが空かのチェック
    # 分岐1
    if email.blank? || password.blank?
      render json: { error: "メールアドレスとパスワードを入力してください" }, status: :bad_request and return
    end

    # ③emailのuserを取得する
    user = User.find_by(email: email)


    # 分岐2
    if user == nil
      render json: { error: "このメールアドレスのユーザーはいません" }, status: :unauthorized and return
    end

    # ④パスワードが一致してるか
    # 分岐3
    if not user.authenticate(password)
      render json: { error: "メールアドレスかパスワードが違います" }, status: :unauthorized and return
    end

    # tokenを作って保存する

    # tokenを発行
    # ⑤ rawのオブジェクトを作る
    # 保存1
    raw = SecureRandom.hex(10)

    # digest
    # 結局これはどうするのか
    # ⑥rawをdigest化する、その時人間が読めるような文字にする
    # 保存2
    digest = Digest::SHA256.hexdigest(raw)


    # userはどうするのか？
    # 誰のトークンかわかる形位なっているか
    # revoked_atは発行直後にその値で良いかどうか
    # ⑦digestでaccess_tokenオブジェクトを作る
    # 保存3
    AccessToken.create!(
      token_digest: digest,
      expires_at: 1.month.from_now,
      revoked_at: nil,
      user_id: user.id
    )

    # クライアントに返す
    #
    # 返却
    # クライアントに返すのは何か。ログイン後にクライアントが今後使うのは何か。emailではなく何が必要か
    # ⑧renderでクライアント側にrawを返す
    render json: { token: raw }, status: 200
    #
  end

  def destroy
    # http headerのauthorizationを取り出す。
    if @active_token != nil

      @active_token.update(revoked_at: Time.now)
      render json: { token: true }, status: :ok and return
    end
      render json: { token: "not token" }, status: :unauthorized and return

    #
    # 有効なaccess_tokenがあるならその中からdigest化したものと照合、なければ401を返す
    # (コーディングする時、そもそも有効なaccess_tokenがない場合の401も同時に返せるようにする)
    #
    # accses_tokenの中のrevoked_atに現在日時を入れて更新をする。これにより失効時間が定義される
    #
    #
    # 成功したらjsonでtrueを返す
  end
end
