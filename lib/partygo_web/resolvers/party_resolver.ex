defmodule PartygoWeb.PartyResolver do
  alias Partygo.Users
  alias Partygo.Parties

  def all_parties(_root, _args, _info) do
    {:ok, Parties.list_parties()}
  end

  def create_party(_root, args, info) do
    args
    |> Map.put(:owner, Users.get_user!(info.context.user_id))
    |> Parties.create_party()
  end

  def delete_party(_root, %{party_id: party_id}, info) do
    case Parties.delete_party(info.context.user_id, party_id) do
      {:error, _} -> {:ok, false}
      :ok -> {:ok, true}
    end
  end

  def update_party(_root, %{party_id: party_id, edit: party_edit}, info) do
    Parties.get_party!(party_id)
    |> Parties.update_party(info.context.user_id, party_edit)
  end

  def parties_near(_root, %{latitude: lat, longitude: long}, _info) do
    {:ok, Parties.get_parties_near(lat, long)}
  end

  def generate_jwt_ticket(%{party_id: party_id}, info) do
    Parties.generate_jwt_ticket(info.context.user_id, party_id)
  end

  def validate_jwt_ticket(%{ticket: jwt, party_id: party_id}, info) do
    case Parties.validate_jwt_ticket(info.context.user_id, party_id, jwt) do
      {:error, _reason} -> {:ok, false}
      ok -> ok
    end
  end
end
