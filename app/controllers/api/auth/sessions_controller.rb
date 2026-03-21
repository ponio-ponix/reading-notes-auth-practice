require 'digest'

class Api::Auth::SessionsController < ApplicationController

  #このアクションはログイン後のトークンを生成する関数である
  def create
    # 入力を受ける
    email = params[:email]
    password = params[:password]

    if email.empty? || password.empty?
      render text: "メールとパスワードが空です" and return 
    end

    # 取得はこれで良いかどうか 
    # nilだったときどうやって対処するか
    user = User.find_by(email: email)

    if user == nil
      render text: "このメールアドレスのユーザーはいません" and return 
    end

    #　本人確認をする

    # パスワードの確認の仕方はイマイチよくわかっていない
    # userがいなかったときどうするか
    # 生の値と加工済みの値を混ぜていないか
    if not user.authenticate(password)
      render text: "メールアドレスかパスワードが違います" and return 
    end

    # tokenを作って保存する

    # tokenを発行
    raw = SecureRandom.hex(10)

    # digest
    # 結局これはどうするのか
    digest = Digest::SHA256.digest(raw)
    digest = Digest.hexencode(digest)


    # userはどうするのか？
    # 誰のトークンかわかる形位なっているか
    # revoked_atは発行直後にその値で良いかどうか
    AccessToken.create!(
      token_digest: digest,
      expires_at: 1.month.from_now,
      revoked_at: nil,
      user_id: user.id
    )

    #クライアントに返す
    #
    #返却
    # クライアントに返すのは何か。ログイン後にクライアントが今後使うのは何か。emailではなく何が必要か
    render json: { token: raw }, status: 200
    #
  end

  def destroy
    # http headerのauthorizationを取り出す。
    # 
    # 取り出したauthorizationヘッダをrawとbearerスキームにsplitする
    # 
    # bearerスキーム出ないのなら401
    # 
    # rawが空の時 401を返す
    # 
    # 照合用にrawをdigest化する
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