defmodule Partygo.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Partygo.Repo

  alias Partygo.Users.User
  alias Partygo.Parties.Party

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.update_changeset(user, attrs)
  end

  @doc """
  Assists a user to a party
  """
  def assist_to_party(user_id, party_id) when is_integer(user_id) and is_integer(party_id) do
    update = from(p in Party,
      where: p.id == ^party_id,
      # nos fijamos que no sea el duenio
      where: p.owner_id != ^user_id,
      # nos fijamos que no este asistiendo
      where: not exists(
        from(au in "assisting_users",
          where: ^party_id == au.party_id and ^user_id == au.user_id,
          select: ["user_id"]
        )
      ),
      # nos fijamos que haya espacio
      where: is_nil(p.assisting_limit) or p.assisting_count < p.assisting_limit,
      update: [inc: [assisting_count: 1]]
    ) |> Repo.update_all([])

    with {1, nil} <- update,
         {1, nil} <- Repo.insert_all("assisting_users", [[user_id: user_id, party_id: party_id]]) do
      :ok
    else
      _ -> {:error, :party_capacity}
    end 
  end
end
