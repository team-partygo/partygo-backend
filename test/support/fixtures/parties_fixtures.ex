defmodule Partygo.PartiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Partygo.Parties` context.
  """

  import Partygo.UsersFixtures

  @doc """
  Generate a party.
  """
  def party_fixture(attrs \\ %{}) do
    user = user_fixture()
    attrs =
      attrs
      |> Enum.into(%{
        age_from: 42,
        age_to: 42,
        date: ~U[3023-02-23 03:12:00Z],
        description: "some description",
        latitude: "120.5",
        longitude: "120.5",
        title: "some name",
      })
    {:ok, party} = Partygo.Parties.create_party(user.id, attrs)

    party
  end
end
