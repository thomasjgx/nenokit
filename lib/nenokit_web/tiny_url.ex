defmodule NenokitWeb.TinyUrl do
  use NenokitWeb.URLShortenerService

  def host, do: "http://tinyurl.com"
  def action, do: "/api-create.php"
  def code, do: 200
  def method, do: "get"
  def param, do: "url"

  def on_response(response) do
    response.body
  end
end