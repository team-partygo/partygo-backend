defmodule Partygo.Parties.Party do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parties" do
    field :age_from, :integer
    field :age_to, :integer
    field :date, :utc_datetime
    field :description, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :title, :string
    belongs_to :owner, Partygo.Users.User
    many_to_many :assisting, Partygo.Users.User,
      join_through: "assisting_users"

    timestamps()
  end

  @doc false
  def changeset(party, attrs) do
    party
    |> cast(attrs, [:title, :description, :date, :latitude, :longitude, :age_from, :age_to])
    |> cast_assoc(:owner, required: true)
    |> cast_assoc(:assisting, required: true)
    |> validate_required([:title, :description, :date, :latitude, :longitude])
  end
end