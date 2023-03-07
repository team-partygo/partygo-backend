defmodule PartygoWeb.UserResolver do
  alias Partygo.Users

  def all_users(_root, _args, _info) do
    {:ok, Users.list_users()}
  end

  def assist_to_party(_root, %{party_id: party_id}, info) do
    case Users.assist_to_party(info.context.user_id, party_id) do
      :ok -> {:ok, true}
      {:error, :party_capacity} -> {:ok, false}
      e -> e
    end
  end
end
