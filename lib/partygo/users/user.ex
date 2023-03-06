defmodule Partygo.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :dob, :date
    field :name, :string
    field :sex, Ecto.Enum, values: [:male, :female]
    field :tag, :string
    has_one :uuid, Partygo.Users.UUID
    has_many :parties, Partygo.Parties.Party, foreign_key: :owner_id
    many_to_many :assisting_to, Partygo.Parties.Party, 
      join_through: "assisting_users"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:tag, :name, :dob, :sex])
    |> put_assoc(:uuid, attrs.uuid)
    |> put_assoc(:parties, attrs.parties)
    |> validate_required([:tag, :name, :dob])
    |> unique_constraint(:tag)
  end
end
