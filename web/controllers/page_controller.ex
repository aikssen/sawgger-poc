defmodule SwaggerPoc.PageController do
  use SwaggerPoc.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
