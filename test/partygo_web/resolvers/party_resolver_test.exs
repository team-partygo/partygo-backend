defmodule Partygo.PartyResolverTest do
  use Partygo.DataCase
  import Ecto.Query
  import Partygo.UsersFixtures
  import Partygo.PartiesFixtures
  alias Partygo.Parties
  alias Partygo.Users
  alias Partygo.Parties.Party
  alias Partygo.Users.User

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

  test "parties_near/3 just gets parties near the specified location" do
    party = party_fixture()
    party_fixture(%{latitude: party.latitude + 25, longitude: party.longitude + 25})

    query = """
    {
      allPartiesNear(latitude: #{party.latitude + 0.003}, longitude: #{party.longitude - 0.003}) {
        id
      }
    }
    """

    assert {:ok, %{data: %{"allPartiesNear" => [%{"id" => id}]}}} = Absinthe.run(query, PartygoWeb.Schema)
    assert party.id == Integer.parse(id) |> elem(0)
  end

  test "generate_jwt_ticket/2 generates a valid ticket" do
    %Party{id: party_id} = party_fixture()
    %User{id: user_id} = user_fixture()
    :ok = Users.assist_to_party(user_id, party_id)

    query = """
    {
      ticketForParty(partyId: #{party_id})
    }
    """

    assert {:ok, %{data: %{"ticketForParty" => jwt}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: user_id})
    assert {:ok, %{"sub" => ^user_id, "pid" => ^party_id}} = Partygo.Token.Ticket.verify_and_validate(jwt)
  end

  test "generate_jwt_ticket/2 does not generate a valid ticket if the user is not assiting" do
    party = party_fixture()
    user = user_fixture()

    query = """
    {
      ticketForParty(partyId: #{party.id})
    }
    """

    assert {:ok, %{data: %{"ticketForParty" => nil}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: user.id})
  end

  test "validate_jwt_ticket/3 returns true if the user is assisting and the owner is scanning the ticket" do
    %Party{id: party_id, owner: %User{id: owner_id}} = party_fixture()
    user = user_fixture()

    :ok = Users.assist_to_party(user.id, party_id)
    {:ok, ticket} = Parties.generate_jwt_ticket(user.id, party_id)
    refute is_nil(ticket)

    query = """
    mutation {
      validateTicket(ticket: "#{ticket}", partyId: #{party_id})
    }
    """

    assert {:ok, %{data: %{"validateTicket" => true}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: owner_id})
    assert {:ok, %{data: %{"validateTicket" => false}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: owner_id})
  end

  test "validate_jwt_ticket/3 returns false if the user is not assisting and the owner is scanning the ticket" do
    %Party{id: party_id, owner: %User{id: owner_id}} = party_fixture()
    user = user_fixture()

    {:ok, ticket, _claims} = Partygo.Token.Ticket.generate_and_sign(%{"sub" => user.id, "pid" => party_id})
    refute is_nil(ticket)

    query = """
    mutation {
      validateTicket(ticket: "#{ticket}", partyId: #{party_id})
    }
    """

    assert {:ok, %{data: %{"validateTicket" => false}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: owner_id})
  end

  test "validate_jwt_ticket/3 returns false if the owner is not scanning the ticket" do
    %Party{id: party_id} = party_fixture()
    user = user_fixture()

    :ok = Users.assist_to_party(user.id, party_id)
    {:ok, ticket} = Parties.generate_jwt_ticket(user.id, party_id)
    refute is_nil(ticket)

    query = """
    mutation {
      validateTicket(ticket: "#{ticket}", partyId: #{party_id})
    }
    """

    assert {:ok, %{data: %{"validateTicket" => false}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: user.id})
  end

  test "validate_jwt_ticket/3 returns false if the ticket is for another party" do
    %Party{id: party_id} = party_fixture()
    %Party{id: other_party_id} = party_fixture()
    user = user_fixture()

    :ok = Users.assist_to_party(user.id, party_id)
    :ok = Users.assist_to_party(user.id, other_party_id)
    {:ok, ticket} = Parties.generate_jwt_ticket(user.id, other_party_id)
    refute is_nil(ticket)

    query = """
    mutation {
      validateTicket(ticket: "#{ticket}", partyId: #{party_id})
    }
    """

    assert {:ok, %{data: %{"validateTicket" => false}}} = Absinthe.run(query, PartygoWeb.Schema, context: %{user_id: user.id})
  end
end
