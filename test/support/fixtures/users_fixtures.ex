defmodule Partygo.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Partygo.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        dob: ~D[2023-02-22],
        email: "some email",
        name: "some name",
        sex: true,
        tag: "some tag",
        uid: "some uid"
      })
      |> Partygo.Users.create_user()

    user
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        dob: ~D[2023-02-22],
        email: "some email",
        female?: true,
        name: "some name",
        tag: "some tag",
        uid: "some uid"
      })
      |> Partygo.Users.create_user()

    user
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        dob: ~D[2023-02-22],
        email: "some email",
        name: "some name",
        sex: :male,
        tag: "some tag",
        uid: "some uid"
      })
      |> Partygo.Users.create_user()

    user
  end

  @doc """
  Generate a unique user tag.
  """
  def unique_user_tag, do: "some tag#{System.unique_integer([:positive])}"

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
        uid: "some uid"
      })
      |> Partygo.Users.create_user()

    user
  end
end
