defmodule BaiWeb.Router do
  use BaiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BaiWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/login", PageController, :login
    post "/login", PageController, :log_in
    get "/logout", PageController, :logout
    get "/action", PageController, :act
    get "/register", PageController, :register
    post "/register", PageController, :register_post
    get "/edit", PageController, :edit
    get "/permissions", PageController, :permissions
  end

  # Other scopes may use custom stacks.
  # scope "/api", BaiWeb do
  #   pipe_through :api
  # end
end
