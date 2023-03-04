defmodule PartygoWeb.UserResolver do
  alias Partygo.Users

  def all_users(_root, _args, _info) do
    {:ok, Users.list_users()}
  end

  def assist_to_party(_root, %{user_id: user_id, party_id: party_id}, _info) do
    case Users.assist_to_party(user_id, party_id) do
      {:ok, _} -> {:ok, true}
      {:error, :party_capacity} -> {:ok, false}
      e -> e
    end
  end
end
