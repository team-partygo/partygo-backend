defmodule PartygoWeb.Token.Google do
  use Joken.Config

  def token_config(), do:
    default_claims(
      aud: "85775491901-sf1ttdlu4v4abu76sd78sm7je07o60lu.apps.googleusercontent.com",
      skip: [:iss]
    ) |> add_claim("iss", nil, &(&1 in ["accounts.google.com", "https://accounts.google.com"]))
end

defmodule PartygoWeb.Plug.Login.Google do
  import Plug.Conn
  import Phoenix.Controller, only: [put_view: 2, render: 2]
  alias Partygo.Users
  alias PartygoWeb.Token.Google, as: Token

  def init(opts), do: opts

  def call(conn, _opts) do
    {:ok, keys} = get_keys()

    with {:ok, token} <- get_jwt(conn) do
      claims = Enum.find_value(keys, fn key -> 
                 case Token.verify_and_validate(token, key) do
                   {:ok, claims} -> claims
                   _ -> nil
                 end
               end)

      if is_nil(claims) or not claims["email_verified"] do
        error(conn, 401)
      else 
        Users.create_uuid(%{
          uuid_source: :google,
          uuid: claims["sub"],
          email: claims["email_verified"]
        })
        ok(conn)
      end
    else
      _ -> error(conn, 400)
    end
  end

  defp get_keys() do
    HTTPoison.start()
    with {:ok, %{status_code: 200, body: body}} <- HTTPoison.get("https://www.googleapis.com/oauth2/v3/certs"),
         {:ok, %{"keys" => keys}} <- Jason.decode(body) do
      {:ok, Enum.map(keys, fn key -> Joken.Signer.create(key["alg"], key) end)}
    end
  end

  defp get_jwt(%Plug.Conn{body_params: %{"credential" => token}}),
    do: {:ok, token}
  defp get_jwt(_conn), do: {:error, :invalid_body}

  defp error(conn, num) do
    conn
    |> put_status(:bad_request)
    |> put_view(PartygoWeb.ErrorView)
    |> render("#{num}.json")
    |> halt
  end

  # TODO: redirect?
  defp ok(conn) do
    conn
    |> send_resp(:no_content, "")
    |> halt
  end
end
