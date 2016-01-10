defmodule PhoenixDown.Router do
  use PhoenixDown.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Openmaize.LoginoutCheck, storage: nil, redirects: false
    plug Openmaize.Authenticate, storage: nil
  end

  scope "/api", PhoenixDown do
    pipe_through :api

    get "/login", UserController, :login, as: :login
    post "/login", UserController, :login_user, as: :login
    get "/logout", UserController, :logout, as: :logout
    get "/me", UserController, :me

    resources "/users/:user_id/user_statuses", UserStatusController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
  end

  scope "/", PhoenixDown do
    pipe_through :browser # Use the default browser stack

    get "/*path", PageController, :index
  end
end
