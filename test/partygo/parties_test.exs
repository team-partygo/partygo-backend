defmodule Partygo.PartiesTest do
  use Partygo.DataCase

  alias Partygo.Parties

  describe "parties" do
    alias Partygo.Parties.Party

    import Partygo.PartiesFixtures

    @invalid_attrs %{age_from: nil, age_to: nil, date: nil, description: nil, latitude: nil, longitude: nil, name: nil}

    test "list_parties/0 returns all parties" do
      party = party_fixture()
      assert Parties.list_parties() == [party]
    end

    test "get_party!/1 returns the party with given id" do
      party = party_fixture()
      assert Parties.get_party!(party.id) == party
    end

    test "create_party/1 with valid data creates a party" do
      valid_attrs = %{age_from: 42, age_to: 42, date: ~U[2023-02-23 03:12:00Z], description: "some description", latitude: "120.5", longitude: "120.5", name: "some name"}

      assert {:ok, %Party{} = party} = Parties.create_party(valid_attrs)
      assert party.age_from == 42
      assert party.age_to == 42
      assert party.date == ~U[2023-02-23 03:12:00Z]
      assert party.description == "some description"
      assert party.latitude == Decimal.new("120.5")
      assert party.longitude == Decimal.new("120.5")
      assert party.name == "some name"
    end

    test "create_party/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Parties.create_party(@invalid_attrs)
    end

    test "update_party/2 with valid data updates the party" do
      party = party_fixture()
      update_attrs = %{age_from: 43, age_to: 43, date: ~U[2023-02-24 03:12:00Z], description: "some updated description", latitude: "456.7", longitude: "456.7", name: "some updated name"}

      assert {:ok, %Party{} = party} = Parties.update_party(party, update_attrs)
      assert party.age_from == 43
      assert party.age_to == 43
      assert party.date == ~U[2023-02-24 03:12:00Z]
      assert party.description == "some updated description"
      assert party.latitude == Decimal.new("456.7")
      assert party.longitude == Decimal.new("456.7")
      assert party.name == "some updated name"
    end

    test "update_party/2 with invalid data returns error changeset" do
      party = party_fixture()
      assert {:error, %Ecto.Changeset{}} = Parties.update_party(party, @invalid_attrs)
      assert party == Parties.get_party!(party.id)
    end

    test "delete_party/1 deletes the party" do
      party = party_fixture()
      assert {:ok, %Party{}} = Parties.delete_party(party)
      assert_raise Ecto.NoResultsError, fn -> Parties.get_party!(party.id) end
    end

    test "change_party/1 returns a party changeset" do
      party = party_fixture()
      assert %Ecto.Changeset{} = Parties.change_party(party)
    end
  end
end
