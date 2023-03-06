defmodule Partygo.UsersTest do
  use Partygo.DataCase

  alias Partygo.Users

  describe "users" do
    alias Partygo.Users.User
    alias Partygo.Parties
    alias Partygo.Repo

    import Partygo.UsersFixtures
    import Partygo.PartiesFixtures

    @invalid_attrs %{dob: nil, email: nil, name: nil, sex: nil, tag: nil, uuid: nil, uuid_source: nil, parties: nil, assisting_to: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() |> Repo.preload([:parties, :assisting_to]) == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) |> Repo.preload([:parties, :assisting_to]) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{dob: ~D[2023-02-23], email: "some email", name: "some name", sex: :male, tag: "some tag", uuid: "some uid", uuid_source: :google, parties: [], assisting_to: []}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.dob == ~D[2023-02-23]
      assert user.email == "some email"
      assert user.name == "some name"
      assert user.sex == :male
      assert user.tag == "some tag"
      assert user.uuid == "some uid"
      assert user.uuid_source == :google
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "some updated email", name: "some updated name", sex: :female, tag: "some updated tag"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert user.sex == :female
      assert user.tag == "some updated tag"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id) |> Repo.preload([:assisting_to, :parties])
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end

    test "assist_to_party/2 assists a user to a party" do
      user = user_fixture()
      party = party_fixture()

      assert :ok == Users.assist_to_party(user.id, party.id)

      party = Parties.get_party!(party.id)
      assert %User{assisting_to: [^party]} = Users.get_user!(user.id) |> Repo.preload(:assisting_to)
    end
  end
end
