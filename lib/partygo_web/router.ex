defmodule PartygoWeb.Router do
  use PartygoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: PartygoWeb.Schema,
      interface: :simple,
      context: %{pubsub: PartygoWeb.Endpoint}
  end
end
