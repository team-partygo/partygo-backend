defmodule Partygo.UserResolverTest do
  use Partygo.DataCase
  import Ecto.Query
  import Partygo.UsersFixtures
  import Partygo.PartiesFixtures
  alias Partygo.Repo
  alias Partygo.Users.User

  test "all_users/3 lists all users" do
    query = """
            {
              allUsers {
                id
              }
            }
            """
    assert {:ok, %{data: %{"allUsers" => users}}} = Absinthe.run(query, PartygoWeb.Schema)

    tags = Enum.map(users, fn %{"id" => t} -> t end) |> Enum.sort
    assert tags == from(u in User, select: u.id) |> Repo.all |> Enum.sort()
  end

  test "assist_to_party/3 assists a user to a party" do
    user = user_fixture()
    party = party_fixture(%{assisting_limit: 1})
    query = """
            mutation {
              assistToParty(partyId: #{party.id})
            }
            """
    
    assert {:ok, %{data: %{"assistToParty" => true}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: user.id})
  end

  test "assist_to_party/3 does not assist an owner to their party" do
    user = user_fixture()
    party = party_fixture(%{owner: user, assisting_limit: 1})
    query = """
    mutation {
      assistToParty(partyId: #{party.id})
    }
    """

    assert {:ok, %{data: %{"assistToParty" => false}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: user.id})
  end

  test "assist_to_party/3 does not assist over the assisting_limit" do
    user = user_fixture()
    other_user = user_fixture()
    party = party_fixture(%{assisting_limit: 1})
    query = """
    mutation {
      assistToParty(partyId: #{party.id})
    }
    """

    assert {:ok, %{data: %{"assistToParty" => true}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: user.id})
    assert {:ok, %{data: %{"assistToParty" => false}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: other_user.id})
  end

  test "assist_to_party/3 does not assist a user twice" do
    user = user_fixture()
    party = party_fixture(%{assisting_limit: 2})
    query = """
    mutation {
      assistToParty(partyId: #{party.id})
    }
    """

    assert {:ok, %{data: %{"assistToParty" => true}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: user.id})
    assert {:ok, %{data: %{"assistToParty" => false}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: user.id})
  end
end
