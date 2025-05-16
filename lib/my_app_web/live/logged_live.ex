defmodule MyAppWeb.LoggedLive do
  use MyAppWeb, :live_view

  @impl true
  def mount(_params, _opts, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>Logged In</h1>
      <p>Welcome to the logged in page!</p>
      <a href="/logout">Logout</a>
    </div>
    """
  end
end
