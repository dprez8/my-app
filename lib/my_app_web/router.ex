defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :login do
    plug MyAppWeb.Plugs.VerifySessionToken, client: MyAppWeb.Keycloak
  end

  pipeline :add_csrf_token do
    plug MyAppWeb.Plugs.AddCsrfToken
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MyAppWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/home", HomeLive, :home
  end

  scope "/", MyAppWeb do
    pipe_through [:add_csrf_token, :browser]

    get "/login_cb", AuthController, :callback
  end

  scope "/", MyAppWeb do
    pipe_through [:add_csrf_token, :browser, :login]

    post "/auth/login", AuthController, :login
    post "/auth/logout", AuthController, :logout
    live "/logged", LoggedLive, :logged
  end

  scope "/", MyAppWeb do
    # Your other routes...

    get "/.well-known/appspecific/com.chrome.devtools.json", FallbackController, :handle_devtools
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:my_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MyAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
