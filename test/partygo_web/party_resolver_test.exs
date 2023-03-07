defmodule Partygo.PartyResolverTest do
  use Partygo.DataCase
  import Ecto.Query
  import Partygo.UsersFixtures
  import Partygo.PartiesFixtures
  alias Partygo.Parties
  alias Partygo.Parties.Party

  test "all_parties/3 lists all parties" do
    query = """
            {
              allParties {
                id
              }
            }
            """
    assert {:ok, %{data: %{"allParties" => users}}} = Absinthe.run(query, PartygoWeb.Schema)

    tags = Enum.map(users, fn %{"id" => t} -> t end) |> Enum.sort
    assert tags == from(u in Party, select: u.id) |> Repo.all |> Enum.sort()
  end

  test "create_party/3 creates a party" do
    user = user_fixture()
    query = """
    mutation {
      createParty(
        title: "test",
        description: "mivi",
        date: "3020-09-01 00:00:00Z",
        latitude: -34.52,
        longitude: 48.3,
        age_from: 18,
        age_to: 99
      ) {
        id
      }
    }
    """

    assert {:ok, %{data: %{"createParty" => %{"id" => id}}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: user.id})
    party = Repo.get!(Party, id) |> Repo.preload([:owner])

    assert party.title == "test"
    assert party.description == "mivi"
    assert party.date == ~U[3020-09-01 00:00:00Z]
    assert party.latitude == -34.52
    assert party.longitude == 48.3
    assert party.age_from == 18
    assert party.age_to == 99
    assert party.owner.id == user.id
  end

  test "delete_party/3 deletes a party if the user is the owner" do
    party = party_fixture()
    query = """
    mutation {
      deleteParty(partyId: #{party.id})
    }
    """

    assert {:ok, %{data: %{"deleteParty" => true}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: party.owner.id})
  end

  test "delete_party/3 does not delete a party if the user is not the owner" do
    party = party_fixture()
    other_user = user_fixture()
    query = """
    mutation {
      deleteParty(partyId: #{party.id})
    }
    """

    assert {:ok, %{data: %{"deleteParty" => false}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: other_user.id})
  end

  test "edit_party/3 edits the party if the user is the owner" do
    party = party_fixture()
    query = """
    mutation {
      editParty(
        partyId: #{party.id},
        edit: {
          description: "edit"
          date: "3024-03-04 00:00:00Z"
        }
      ) {
        id
      }
    }
    """

    assert {:ok, %{data: %{"editParty" => %{"id" => id}}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: party.owner.id})
    updated = Parties.get_party!(id)

    assert updated.id == party.id
    assert updated.description == "edit"
    assert updated.date == ~U[3024-03-04 00:00:00Z]
  end

  test "edit_party/3 does not edit the party if the user is not the owner" do
    party = party_fixture()
    other_user = user_fixture()
    query = """
    mutation {
      editParty(
        partyId: #{party.id},
        edit: {
          description: "edit"
          date: "3024-03-04 00:00:00Z"
        }
      ) {
        id
      }
    }
    """

    assert {:ok, %{data: %{"editParty" => nil}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: other_user.id})

    updated = Parties.get_party!(party.id)
    refute updated.description == "edit"
    refute updated.date == ~U[3024-03-04 00:00:00Z]
  end
end
