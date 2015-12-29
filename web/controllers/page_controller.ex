defmodule PhoenixDown.PageController do
  use PhoenixDown.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
