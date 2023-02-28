defmodule Partygo.Dataloader do
  def data(), do: Dataloader.Ecto.new(Partygo.Repo, query: &query/2)

  def query(queryable, _params) do
    queryable
  end
end
