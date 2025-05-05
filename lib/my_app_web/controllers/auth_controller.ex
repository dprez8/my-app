defmodule MyAppWeb.AuthController do
  use MyAppWeb, :controller
  alias MyAppWeb.Keycloak

  def login(conn, _params) do
    redirect(conn, external: Keycloak.authorize_url!())
  end

  def callback(conn, params) do
    params = for {key, value} <- params, do: {String.to_atom(key), value}
    #params = Enum.into(params, [])
    case Keycloak.get_token!(params) do
      {:ok, token} ->
        IO.inspect(token, label: "Token")
        conn
        |> put_session(:token, token)
        |> redirect(to: "/")
      %OAuth2.Client{token: token} ->
        conn
        |> put_session(:token, token)
        |> redirect(to: "/")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: "/")
    end
  end

  def logout(conn, _params) do
    session = fetch_session(conn)
    IO.inspect(session, label: "Session")

    case session.private.plug_session["token"] do
      nil ->
        IO.puts("Session private is nil")
        conn
        |> put_flash(:info, "You are already logged out")
        |> redirect(to: "/")

        token ->
          IO.inspect(token, label: "Token")
          Keycloak.revoke_token(token)
    end

    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
