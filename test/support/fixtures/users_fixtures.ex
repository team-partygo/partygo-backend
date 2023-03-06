defmodule Partygo.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Partygo.Users` context.
  """

  alias Partygo.Repo

  @doc """
  Generate a unique user tag.
  """
  def unique_user_tag, do: "some tag#{System.unique_integer([:positive])}"
  def unique_uuid, do: "some uuid#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        dob: ~D[2023-02-23],
        email: "some email",
        name: "some name",
        sex: :male,
        tag: unique_user_tag(),
        uuid: unique_uuid(),
        uuid_source: :google,
        assisting_to: [],
        parties: [],
      })
      |> Partygo.Users.create_user()

    user |> Repo.preload([:parties, :assisting_to])
  end
end
