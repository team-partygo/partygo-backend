defmodule Partygo.PartiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Partygo.Parties` context.
  """

  import Partygo.UsersFixtures
  alias Partygo.Users.User
  alias Partygo.Repo

  @doc """
  Generate a party.
  """
  def party_fixture(attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        age_from: 42,
        age_to: 42,
        date: ~U[3023-02-23 03:12:00Z],
        description: "some description",
        latitude: 120.5,
        longitude: 120.5,
        title: "some name",
        owner: user_fixture(),
      })

    {:ok, party} = Partygo.Parties.create_party(attrs)

    %{party | owner: Repo.get!(User, attrs.owner.id) |> Repo.preload([:assisting_to, :parties])}
  end
end
