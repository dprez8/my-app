defmodule MyAppWeb.Plugs.TokenCheck do
  use MyAppWeb, :plug

  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    Logger.debug("[Plug][KeycloakEx.VerifyBearerToken] - Check Token!")

    case get_req_header(conn, "authorization") do
      header when header == [] or header == nil ->
        conn
        |> put_req_header("authorization", "Bearer unset_token")

      _ ->
        conn
    end
  end
end
