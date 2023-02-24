defmodule PartygoWeb.UserResolver do
  alias Partygo.Users

  def all_users(_root, _args, _info) do
    {:ok, Users.list_users()}
  end
end
