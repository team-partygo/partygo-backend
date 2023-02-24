defmodule Partygo.PartiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Partygo.Parties` context.
  """

  @doc """
  Generate a party.
  """
  def party_fixture(attrs \\ %{}) do
    {:ok, party} =
      attrs
      |> Enum.into(%{
        age_from: 42,
        age_to: 42,
        date: ~U[2023-02-23 03:12:00Z],
        description: "some description",
        latitude: "120.5",
        longitude: "120.5",
        name: "some name"
      })
      |> Partygo.Parties.create_party()

    party
  end
end
