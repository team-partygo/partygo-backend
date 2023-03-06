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
  import Phoenix.Controller, only: [put_view: 2, render: 2]
  alias PartygoWeb.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, jwt} <- get_header(conn),
         {:ok, claims} <- Token.verify_and_validate(jwt) do
      Absinthe.Plug.put_options(conn, context: %{user_id: claims["sub"]})
    else 
      _ -> unauthorized(conn)
    end
  end

  defp get_header(conn) do 
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> {:ok, token}
      _ -> {:error, :no_token}
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> put_view(PartygoWeb.ErrorView)
    |> render("401.json")
    |> halt
  end
end
