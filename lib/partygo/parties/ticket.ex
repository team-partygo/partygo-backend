defmodule Partygo.Token.Ticket do
  use Joken.Config

  @impl true
  def token_config(), do:
    default_claims(
      aud: "partyGO_webclient",
      iss: "partyGO_server",
      skip: [:jti]
    ) |> add_claim("sub", nil, &is_number/1)
      |> add_claim("pid", nil, &is_number/1)
end
