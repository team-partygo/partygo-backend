defmodule Partygo.PartiesTest do
  use Partygo.DataCase

  alias Partygo.Parties

  describe "parties" do
    alias Partygo.Parties.Party
    alias Partygo.Repo

    import Partygo.PartiesFixtures
    import Partygo.UsersFixtures

    @invalid_attrs %{age_from: nil, age_to: nil, date: nil, description: nil, latitude: nil, longitude: nil, name: nil, owner: nil}

    test "list_parties/0 returns all parties" do
      party = party_fixture()
      assert Parties.list_parties() |> Repo.preload(owner: [:assisting_to, :parties], assisting: []) == [party] 
    end

    test "get_party!/1 returns the party with given id" do
      party = party_fixture()
      assert Parties.get_party!(party.id) |> Repo.preload(owner: [:assisting_to, :parties], assisting: []) == party
    end

    test "create_party/2 with valid data creates a party" do
      user = user_fixture()
      valid_attrs = %{age_from: 42, age_to: 42, date: ~U[3023-02-23 03:12:00Z], description: "some description", latitude: 120.5, longitude: 120.5, title: "some name", owner: user}

      assert {:ok, %Party{} = party} = Parties.create_party(valid_attrs)
      party = Repo.preload(party, owner: [:assisting_to, :parties], assisting: [])

      assert party.age_from == 42
      assert party.age_to == 42
      assert party.date == ~U[3023-02-23 03:12:00Z]
      assert party.description == "some description"
      assert party.latitude == 120.5
      assert party.longitude == 120.5
      assert party.title == "some name"
      assert party.assisting == []
      assert party.owner.id == user.id
    end

    test "create_party/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Parties.create_party(@invalid_attrs)
    end

    test "update_party/3 with valid data updates the party" do
      party = party_fixture()
      update_attrs = %{date: ~U[3023-02-24 03:12:00Z], description: "some updated description"}

      assert {:ok, %Party{} = party} = Parties.update_party(party, party.owner.id, update_attrs)
      assert party.date == ~U[3023-02-24 03:12:00Z]
      assert party.description == "some updated description"
    end

    test "update_party/3 with invalid data returns error changeset" do
      party = party_fixture()
      assert {:error, %Ecto.Changeset{}} = Parties.update_party(party, party.owner.id, @invalid_attrs)
      assert party == Parties.get_party!(party.id) |> Repo.preload(assisting: [], owner: [:assisting_to, :parties])
    end

    test "delete_party/2 deletes the party" do
      party = party_fixture()
      assert :ok = Parties.delete_party(party.owner.id, party.id)
      assert_raise Ecto.NoResultsError, fn -> Parties.get_party!(party.id) end
    end

    test "delete_party/2 does not delete a party if the owner id doesn't match" do
      party = party_fixture()
      user = user_fixture()

      assert {:error, :invalid_permissions} = Parties.delete_party(user.id, party.id)
      assert %Party{} = Parties.get_party!(party.id)
    end

    test "change_party/1 returns a party changeset" do
      party = party_fixture()
      assert %Ecto.Changeset{} = Parties.change_party(party)
    end
  end
end
