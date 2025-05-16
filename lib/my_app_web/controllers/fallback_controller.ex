defmodule MyAppWeb.FallbackController do
  use MyAppWeb, :controller

  def handle_devtools(conn, _params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, "{}")
  end
end
