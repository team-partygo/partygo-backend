defmodule Partygo.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :dob, :date
    field :email, :string
    field :name, :string
    field :sex, Ecto.Enum, values: [:male, :female]
    field :tag, :string
    field :uid, :string, redact: true
    has_many :parties, Partygo.Parties.Party, foreign_key: :owner_id
    many_to_many :assisting_to, Partygo.Parties.Party, 
      join_through: "assisting_users"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:uid, :tag, :name, :dob, :sex, :email])
    |> put_assoc(:parties, attrs.parties)
    |> validate_required([:uid, :tag, :name, :dob, :email])
    |> unique_constraint(:tag)
  end
end
