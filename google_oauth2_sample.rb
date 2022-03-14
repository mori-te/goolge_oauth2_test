#
# Google 認証サンプル
#
require 'sinatra'
require 'sinatra/reloader'
require 'json'
require './httpc'

config_data = JSON.parse(File.open("config.json").read)
client_id = config_data["web"]["client_id"]
client_secret = config_data["web"]["client_secret"]
project_id = config_data["web"]["project_id"]

TOP_URL = "http://localhost:4567"
AUTH_URL = "http://localhost:4567/auth"
AUTH_ENDPOINT = "https://accounts.google.com/o/oauth2/auth"
TOKEN_ENDPOINT = "https://oauth2.googleapis.com/token"
LOGOUT_ENDPOINT = "https://www.google.com/accounts/Logout"
GRAPH_PROFILE_ENDPOINT = "https://people.googleapis.com/v1/people/me"

httpc = AzureAD::HTTPClient.new

# 初期設定
configure do
  use Rack::Session::Pool
end

# サイトトップ
get '/' do
  '<a href="/auth">LOGIN</a>'
end

# 認証（Google認証画面へリダイレクト）
get '/auth' do
  request_params = {
    client_id: client_id,
    response_type: "code",
    redirect_uri: AUTH_URL,
    scope: "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email",
    response_mode: "form_post"
  }
  redirect AUTH_ENDPOINT + "?" + URI.encode_www_form(request_params)  
end

# トークン請求＆取得
post '/auth' do
  code = params[:code]
  header = {
    "Content-Type": "application/x-www-form-urlencoded"
  }
  request_params = {
    client_id: client_id,
    client_secret: client_secret,
    code: code,
    redirect_uri: AUTH_URL,
    grant_type: "authorization_code"
  }
  res = httpc.post(TOKEN_ENDPOINT, request_params, header)
  session["token"] = JSON.parse(res.body)
  p session["token"]
  redirect to("/disp")
end

# GRAPH API使用処理
get '/disp' do
  header = {
    Authorization: "Bearer " + session["token"]["access_token"]
  }
  body = {
    personFields: "names,emailAddresses"
  }
  res = httpc.get(GRAPH_PROFILE_ENDPOINT, body, header)
  p res.body
  JSON.pretty_generate(JSON.parse(res.body))
    .gsub(/\n/, "<br>\n").gsub("  ", " &nbsp;") + "<br><br>" + %(<a href="/logout">LOGOUT</a>)
end

# ログアウト
get '/logout' do
  session.clear
  request_params = {
    client_id: client_id,
    continue: "https://appengine.google.com/_ah/logout?continue=#{TOP_URL}"
  }
  p LOGOUT_ENDPOINT + "?" + URI.encode_www_form(request_params)
  redirect LOGOUT_ENDPOINT + "?" + URI.encode_www_form(request_params)
end