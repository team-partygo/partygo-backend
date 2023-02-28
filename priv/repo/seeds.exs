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
alias Partygo.Parties.Party
alias Partygo.Repo

berto = User.changeset(%User{}, %{dob: ~D[2001-04-04], email: "tomasberto85@gmail.com", name: "bt", sex: :male, tag: "tombertoli", uid: "1234"}) |> Repo.insert!
pulga = User.changeset(%User{}, %{dob: ~D[2001-05-04], email: "antoniopacosantos@gmail.com", name: "pulguita", sex: :male, tag: "pulga", uid: "5678"}) |> Repo.insert!
nn = User.changeset(%User{}, %{dob: ~D[2001-05-04], email: "antoniopacosantos@gmail.com", name: "pulguita", tag: "nn", uid: "5678"}) |> Repo.insert!

Party.changeset(%Party{}, %{date: ~U[2023-05-04 21:00:00Z], description: "Cumple de pulga ololo", latitude: -34.561631, longitude: -58.480185, title: "Cumple de pulga", owner: pulga, assisting: [berto]})
  |> Repo.insert!

