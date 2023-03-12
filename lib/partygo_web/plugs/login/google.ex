defmodule PartygoWeb.Token.Google do
  use Joken.Config

  def token_config(), do:
    default_claims(
      aud: "85775491901-sf1ttdlu4v4abu76sd78sm7je07o60lu.apps.googleusercontent.com",
      skip: [:iss]
    ) |> add_claim("iss", nil, &(&1 in ["accounts.google.com", "https://accounts.google.com"]))
end

defmodule PartygoWeb.Plug.Login.Google do
  import Ecto.Query
  import Plug.Conn
  import Phoenix.Controller, only: [put_view: 2, render: 2]
  alias Partygo.Repo
  alias Partygo.Users
  alias Partygo.Users.User
  alias PartygoWeb.Token.Google, as: GoogleToken
  alias PartygoWeb.Token.UserId, as: Token

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, token} <- get_jwt(conn),
         {:ok, claims} <- get_claims(token),
         {:ok, %User{id: uid}} <- get_user(conn, claims),
         {:ok, token, _claims} <- Token.generate_and_sign(%{"sub" => uid}) do
      ok(conn, token)
    else
      _ -> error(conn, 400)
    end
  end

  defp get_user(conn, claims) do
    case User
         |> where([u], u.uuid_source == :google and u.uuid == ^claims["sub"])
         |> Repo.one() do
      nil -> conn.body_params
             |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
             |> Map.merge(%{
               uuid_source: :google,
               uuid: claims["sub"],
               email: claims["email"],
               parties: [],
             }) 
             |> Users.create_user()
      user -> {:ok, user}
    end
  end

  defp get_claims(token) do
    {:ok, keys} = get_keys()

    claims = Enum.find_value(keys, fn key -> 
               case GoogleToken.verify_and_validate(token, key) do
                 {:ok, claims} -> claims
                 _ -> nil
               end
             end)

    if is_nil(claims) or not claims["email_verified"], 
      do: {:error, :invalid_token},
      else: {:ok, claims}
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

  defp ok(conn, token) do
    conn
    |> send_resp(:ok, token)
    |> halt
  end
end
