defmodule MyAppWeb.Keycloak do
  use KeycloakEx.Client.User,
    otp_app: :my_app
end
