defmodule PartygoWeb.PartyResolver do
  alias Partygo.Parties

  def all_parties(_root, _args, _info) do
    {:ok, Parties.list_parties()}
  end

  def create_party(_root, args, _info) do
    Parties.create_party(args)
  end
end
