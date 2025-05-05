defmodule MyAppWeb.HomeLive do
  use MyAppWeb, :live_view

  @impl true
  def mount(_params, _opts, socket) do
    {:ok, socket}
  end
end
