defmodule Partygo.Parties do
  @moduledoc """
  The Parties context.
  """

  import Ecto.Query, warn: false
  alias Partygo.Repo

  alias Partygo.Parties.Party
  alias Partygo.Users.User

  @doc """
  Returns the list of parties.

  ## Examples

      iex> list_parties()
      [%Party{}, ...]

  """
  def list_parties do
    Repo.all(Party)
  end

  @doc """
  Gets a single party.

  Raises `Ecto.NoResultsError` if the Party does not exist.

  ## Examples

      iex> get_party!(123)
      %Party{}

      iex> get_party!(456)
      ** (Ecto.NoResultsError)

  """
  def get_party!(id), do: Repo.get!(Party, id)

  @doc """
  Creates a party.

  ## Examples

      iex> create_party(%{field: value})
      {:ok, %Party{}}

      iex> create_party(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_party(owner_id, attrs \\ %{}) do
    owner = Repo.get(User, owner_id)
    attrs = attrs
            |> Map.put(:owner, owner)
            |> Map.put(:assisting, [])

    %Party{}
    |> Party.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a party.

  ## Examples

      iex> update_party(party, %{field: new_value})
      {:ok, %Party{}}

      iex> update_party(party, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_party(%Party{owner_id: owner_id} = party, owner_id, attrs) do
    party
    |> Party.edit_changeset(attrs)
    |> Repo.update()
  end
  def update_party(%Party{}, _owner_id, _attrs) do
    {:error, "party not owned by the user modifying it"}
  end

  @doc """
  Deletes a party.

  ## Examples

      iex> delete_party(party)
      {:ok, %Party{}}

      iex> delete_party(party)
      {:error, %Ecto.Changeset{}}

  """
  def delete_party(owner_id, party_id) do
    case from(p in Party,
      where: p.owner_id == ^owner_id,
      where: p.id == ^party_id)
      |> Repo.delete_all do
      {1, _} -> :ok
      {0, _} -> {:error, :invalid_permissions}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking party changes.

  ## Examples

      iex> change_party(party)
      %Ecto.Changeset{data: %Party{}}

  """
  def change_party(%Party{} = party, attrs \\ %{}) do
    Party.edit_changeset(party, attrs)
  end

  @doc """
  Returns parties near a specific location
  """
  def get_parties_near(lat, long) when is_float(lat) and is_float(long) do
    geohash = Geohash.encode(lat, long, 5)
    neighbors = geohash
                |> Geohash.neighbors()
                |> Enum.map(fn {_, v} -> v end)

    Party
    |> where([p], p.geohash in ^[geohash | neighbors])
    |> Repo.all
  end
end
