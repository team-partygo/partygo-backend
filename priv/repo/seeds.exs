# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Partygo.Repo.insert!(%Partygo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Partygo.Users.User
alias Partygo.Repo

%User{dob: ~D[2001-04-04], email: "tomasberto85@gmail.com", name: "bt", sex: :male, tag: "tombertoli", uid: "1234"} |> Repo.insert!
%User{dob: ~D[2001-05-04], email: "antoniopacosantos@gmail.com", name: "pulguita", sex: :male, tag: "pulga", uid: "5678"} |> Repo.insert!

