defmodule NenokitWeb.Router do
  use NenokitWeb, :router

  import NenokitWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user

    # Plug to load navigation menu into the assigns
    plug NenokitWeb.Plugs.LoadNavigation
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Use ensure only admins can access this routes and use admin layout
  pipeline :admin do
    plug NenokitWeb.Plug.EnsureAdmin
    plug :put_layout, {NenokitWeb.LayoutView, :admin}
  end

  # Pipeline to ensure that settings are loaded
  pipeline :settings do
    plug NenokitWeb.Plugs.LoadSettings
  end

  # Manage pages
  pipeline :manage_pages do
    plug NenokitWeb.Plug.EnsurePermission, "manage_pages"
  end

  # Manage blogs
  pipeline :manage_blogs do
    plug NenokitWeb.Plug.EnsurePermission, "manage_blogs"
  end

  # Manage surveys
  pipeline :manage_surveys do
    plug NenokitWeb.Plug.EnsurePermission, "manage_surveys"
  end

  # Manage users
  pipeline :manage_users do
    plug NenokitWeb.Plug.EnsurePermission, "manage_users"
  end

  # Manage roles
  pipeline :manage_roles do
    plug NenokitWeb.Plug.EnsurePermission, "manage_users"
  end

  # Manage settings
  pipeline :manage_settings do
    plug NenokitWeb.Plug.EnsurePermission, "manage_settings"
  end

  # First run setup
  scope "/setup", NenokitWeb do
    pipe_through [:browser]

    resources "/", SetupController, only: [:index, :create]
  end

  scope "/", NenokitWeb do
    pipe_through [:browser, :settings]

    get "/", PageController, :index
    get "/page/:id", PageController, :page
    get "/blog/:id", PageController, :blog
    post "/search", PageController, :search

    get "/survey/:id", SurveyController, :view
    post "/survey/:id", SurveyController, :submit
  end

  ## Authentication routes
  scope "/", NenokitWeb do
    pipe_through [:browser, :settings, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/login", UserSessionController, :new
    post "/users/login", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", NenokitWeb do
    pipe_through [:browser, :settings, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_email", UserSettingsController, :update_email
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", NenokitWeb do
    pipe_through [:browser, :settings]

    delete "/users/logout", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  # Admin dashboard
  scope "/admin", NenokitWeb do
    pipe_through [:browser, :settings, :require_authenticated_user, :admin]

    # Dashboard
    get "/", AdminController, :index
  end

  # Admin: Manage pages
  scope "/admin", NenokitWeb do
    pipe_through [:browser, :settings, :require_authenticated_user, :admin, :manage_pages]

    # Pages management
    resources "/pages", AdminPageController

    # Main menus management
    resources "/main-menus", AdminMainMenuController

    # Page menus management
    resources "/pages/:parent_page_id/menus", AdminPageMenuController
  end

   # Admin: Manage blogs
  scope "/admin/blogs", NenokitWeb do
    pipe_through [:browser, :settings, :require_authenticated_user, :admin, :manage_blogs]

    # Blogs management
    resources "/", AdminBlogController
  end

  # Admin: Manage surveys
  scope "/admin/surveys", NenokitWeb do
    pipe_through [:browser, :settings, :require_authenticated_user, :admin, :manage_surveys]

    # Blogs management
    resources "/", AdminSurveyController
    get "/:id/show-submission/:submission_id", AdminSurveyController, :show_submission
  end

  # Admin: Manage users
  scope "/admin/users", NenokitWeb do
    pipe_through [:browser, :settings, :require_authenticated_user, :admin, :manage_users]

    # Users management
    resources "/", AdminUserController
  end

  # Admin: Manage roles
  scope "/admin/roles", NenokitWeb do
    pipe_through [:browser, :settings, :require_authenticated_user, :admin, :manage_roles]

    # Roles management
    resources "/", AdminRoleController
  end

  # Admin: Manage settings
  scope "/admin/settings", NenokitWeb do
    pipe_through [:browser, :settings, :require_authenticated_user, :admin, :manage_settings]

    # Settings management
    get "/settings/edit", SettingsController, :edit
    put "/settings/update", SettingsController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", NenokitWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: NenokitWeb.Telemetry
    end

    # Bmaboo email viewer
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
