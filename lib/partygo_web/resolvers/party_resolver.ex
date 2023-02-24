defmodule PartygoWeb.PartyResolver do
  alias Partygo.Parties

  def all_parties(_root, _args, _info) do
    {:ok, Parties.list_parties()}
  end
end
