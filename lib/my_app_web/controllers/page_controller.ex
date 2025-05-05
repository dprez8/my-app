defmodule MyAppWeb.PageController do
  use MyAppWeb, :controller

  ##plug MyAppWeb.Plugs.TokenCheck
  plug MyAppWeb.Plugs.VerifySessionToken, client: MyAppWeb.Keycloak
  #plug KeycloakEx.VerifyBearerToken, client: MyAppWeb.Keycloak

  def home(conn, _params) do
    IO.puts("PageController.home")
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
