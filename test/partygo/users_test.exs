defmodule Partygo.UsersTest do
  use Partygo.DataCase

  alias Partygo.Users

  describe "users" do
    alias Partygo.Users.User

    import Partygo.UsersFixtures

    @invalid_attrs %{dob: nil, email: nil, name: nil, sex: nil, tag: nil, uid: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{dob: ~D[2023-02-22], email: "some email", name: "some name", sex: true, tag: "some tag", uid: "some uid"}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.dob == ~D[2023-02-22]
      assert user.email == "some email"
      assert user.name == "some name"
      assert user.sex == true
      assert user.tag == "some tag"
      assert user.uid == "some uid"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{dob: ~D[2023-02-23], email: "some updated email", name: "some updated name", sex: false, tag: "some updated tag", uid: "some updated uid"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.dob == ~D[2023-02-23]
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert user.sex == false
      assert user.tag == "some updated tag"
      assert user.uid == "some updated uid"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
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
  end

  describe "users" do
    alias Partygo.Users.User

    import Partygo.UsersFixtures

    @invalid_attrs %{dob: nil, email: nil, female?: nil, name: nil, tag: nil, uid: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{dob: ~D[2023-02-22], email: "some email", female?: true, name: "some name", tag: "some tag", uid: "some uid"}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.dob == ~D[2023-02-22]
      assert user.email == "some email"
      assert user.female? == true
      assert user.name == "some name"
      assert user.tag == "some tag"
      assert user.uid == "some uid"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{dob: ~D[2023-02-23], email: "some updated email", female?: false, name: "some updated name", tag: "some updated tag", uid: "some updated uid"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.dob == ~D[2023-02-23]
      assert user.email == "some updated email"
      assert user.female? == false
      assert user.name == "some updated name"
      assert user.tag == "some updated tag"
      assert user.uid == "some updated uid"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
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
  end

  describe "users" do
    alias Partygo.Users.User

    import Partygo.UsersFixtures

    @invalid_attrs %{dob: nil, email: nil, name: nil, sex: nil, tag: nil, uid: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{dob: ~D[2023-02-22], email: "some email", name: "some name", sex: :male, tag: "some tag", uid: "some uid"}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.dob == ~D[2023-02-22]
      assert user.email == "some email"
      assert user.name == "some name"
      assert user.sex == :male
      assert user.tag == "some tag"
      assert user.uid == "some uid"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{dob: ~D[2023-02-23], email: "some updated email", name: "some updated name", sex: :female, tag: "some updated tag", uid: "some updated uid"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.dob == ~D[2023-02-23]
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert user.sex == :female
      assert user.tag == "some updated tag"
      assert user.uid == "some updated uid"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
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
  end

  describe "users" do
    alias Partygo.Users.User

    import Partygo.UsersFixtures

    @invalid_attrs %{dob: nil, email: nil, name: nil, sex: nil, tag: nil, uid: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{dob: ~D[2023-02-23], email: "some email", name: "some name", sex: :male, tag: "some tag", uid: "some uid"}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.dob == ~D[2023-02-23]
      assert user.email == "some email"
      assert user.name == "some name"
      assert user.sex == :male
      assert user.tag == "some tag"
      assert user.uid == "some uid"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{dob: ~D[2023-02-24], email: "some updated email", name: "some updated name", sex: :female, tag: "some updated tag", uid: "some updated uid"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.dob == ~D[2023-02-24]
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert user.sex == :female
      assert user.tag == "some updated tag"
      assert user.uid == "some updated uid"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
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
  end
end
