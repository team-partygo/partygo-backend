defmodule Partygo.UserResolverTest do
  use Partygo.DataCase
  import Ecto.Query
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
    query = """
            mutation {
              assistToParty(partyId: 1) {
                
              }
            }
            """
  end
end
