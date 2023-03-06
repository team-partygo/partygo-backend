defmodule Partygo.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :uuid_source, Ecto.Enum, values: [:google, :apple]
    field :uuid, :string
    field :dob, :date
    field :name, :string
    field :sex, Ecto.Enum, values: [:male, :female]
    field :tag, :string
    field :email, :string
    has_many :parties, Partygo.Parties.Party, foreign_key: :owner_id
    many_to_many :assisting_to, Partygo.Parties.Party, 
      join_through: "assisting_users"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:tag, :name, :dob, :sex, :email, :uuid_source, :uuid])
    |> put_assoc(:parties, attrs.parties)
    |> validate_required([:tag, :name, :dob, :email, :uuid_source, :uuid])
    |> unique_constraint(:tag)
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:tag, :name, :sex, :email])
    |> validate_required([:tag, :name, :sex, :email])
    |> unique_constraint(:tag)
  end
end
