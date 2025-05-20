defmodule MyAppWeb.LoggedLive do
  use MyAppWeb, :live_view

  @impl true
  def mount(_params, opts, socket) do
    token = Map.get(opts, "token")

    access_token = token |> Map.get(:access_token)
    refresh_token = token |> Map.get(:refresh_token)
    expires_at = token |> Map.get(:expires_at)

    socket =
      socket
      |> assign(:access_token, access_token)
      |> assign(:refresh_token, refresh_token)
      |> assign(:expires_at, expires_at)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>Logged In</h1>
      <p>Welcome to the logged in page!</p>
      <div class="token-info">
        <h2>Token Information</h2>
        <div>
          <p><strong>Access Token:</strong> {@access_token}</p>
          <p><strong>Refresh Token:</strong> {@refresh_token}</p>
          <p><strong>Expires At:</strong> {@expires_at}</p>
        </div>
      </div>
    </div>
    """
  end
end
