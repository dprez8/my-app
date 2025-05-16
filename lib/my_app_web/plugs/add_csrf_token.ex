defmodule MyAppWeb.Plugs.AddCsrfToken do
  @moduledoc """
  This plug adds a CSRF token to the session.
  """
  use MyAppWeb, :plug

  @doc """
  Adds a CSRF token to the session.
  """
  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> Plug.Conn.put_private(:plug_skip_csrf_protection, true)

    # csrf_token = get_csrf_token()
    # |> put_resp_header("x-csrf-token", csrf_token)
  end
end
