defmodule PartygoWeb.Router do
  use PartygoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug PartygoWeb.JWTPlug
  end

  scope "/api" do
    pipe_through :api
    forward "/", Absinthe.Plug, 
      schema: PartygoWeb.Schema, 
      context: %{pubsub: PartygoWeb.Endpoint}
  end

  scope "/" do
    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: PartygoWeb.Schema,
      interface: :playground,
      context: %{pubsub: PartygoWeb.Endpoint}
  end
end
