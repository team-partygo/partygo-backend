defmodule PartygoWeb.PartyResolver do
  alias Partygo.Parties

  def all_parties(_root, _args, _info) do
    {:ok, Parties.list_parties()}
  end

  def create_party(_root, args, _info) do
    Parties.create_party(args)
  end

  def delete_party(_root, %{party_id: party_id, owner_id: owner_id} = _args, _info) do
    case Parties.delete_party(owner_id, party_id) do
      {0, _} -> {:ok, false}
      _ -> {:ok, true}
    end
  end

  def update_party(_root, %{owner_id: owner_id, party_id: party_id, edit: party_edit} = _args, _info) do
    Parties.get_party!(party_id)
    |> Parties.update_party(owner_id, party_edit)
  end

  def parties_near(_root, %{latitude: lat, longitude: long} = _args, _info) do
    {:ok, Parties.get_parties_near(lat, long)}
  end
end
