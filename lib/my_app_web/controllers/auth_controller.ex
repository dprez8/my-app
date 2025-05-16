defmodule MyAppWeb.AuthController do
  use MyAppWeb, :controller
  alias MyAppWeb.Keycloak
  require Logger

  def login(conn, _params) do
    redirect(conn, external: Keycloak.authorize_url!())
  end

  def callback(conn, params) do
    params = for {key, value} <- params, do: {String.to_atom(key), value}

    case Keycloak.get_token!(params) do
      %OAuth2.Client{token: token} ->
        conn
        |> put_session(:token, token)
        |> redirect(to: "/logged")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: "/")
    end
  end

  def logout(conn, _params) do
    session = fetch_session(conn)

    case session.private.plug_session["token"] do
      nil ->
        conn
        |> put_flash(:info, "You are already logged out")
        |> redirect(to: "/")

      token ->
        conn
        |> configure_session(drop: true)
        |> logout_token(token.access_token)
    end
  end

  def logout_token(conn, token) do
    conf = Application.get_env(:my_app, MyAppWeb.Keycloak)

    url =
      "#{conf[:host_uri]}/realms/#{conf[:realm]}/protocol/openid-connect/logout?client_id=#{conf[:client_id]}&token=#{token}&post_logout_redirect_uri=#{conf[:site]}/"

    redirect(conn, external: url)
  end
end
