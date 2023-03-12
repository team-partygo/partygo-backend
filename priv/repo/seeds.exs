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

berto = User.changeset(%User{}, %{dob: ~D[2001-04-04], name: "bt", sex: :male, tag: "tombertoli", uuid_source: :google, uuid: "1234", email: "tomasberto85@gmail.com", parties: []}) |> Repo.insert!
pulga = User.changeset(%User{}, %{dob: ~D[2001-05-04], name: "pulguita", sex: :male, tag: "pulga", uuid_source: :google, uuid: "5678", email: "antoniopacosantos@gmail.com", parties: []}) |> Repo.insert!
nn = User.changeset(%User{}, %{dob: ~D[2001-05-04], name: "pulguita", tag: "nn", uuid_source: :google, uuid: "9111", email: "antoniopacosantos@gmail.com", parties: []}) |> Repo.insert!

party = Party.changeset(%Party{}, %{date: ~U[2023-05-04 21:00:00Z], description: "Cumple de pulga ololo", latitude: -34.561631, longitude: -58.480185, title: "Cumple de pulga", owner: pulga})
        |> Repo.insert!

:ok = Partygo.Users.assist_to_party(berto.id, party.id)
:ok = Partygo.Users.assist_to_party(nn.id, party.id) 
