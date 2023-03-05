defmodule PartygoWeb.Token do
  use Joken.Config

  @impl true
  def token_config(), do:
    default_claims(
      aud: "partyGO_webclient", 
      iss: "partyGO_server",
      skip: [:jti]
    ) |> add_claim("sub", nil, &is_number/1)
end

defmodule PartygoWeb.JWTPlug do
  import Plug.Conn
  alias PartygoWeb.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_header(conn) |> parse_jwt() do
      {:ok, claims} -> Absinthe.Plug.put_options(conn, context: %{user_id: claims["sub"]})
      {:error, _} -> unauthorized(conn)
    end
  end

  def parse_jwt({:ok, jwt}), do: Token.verify_and_validate(jwt)
  def parse_jwt(e), do: e

  def get_header(conn) do 
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> {:ok, token}
      _ -> {:error, :no_token}
    end
  end

  def unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.render(PartygoWeb.ErrorView, "401.json")
    |> halt
  end
end
