defmodule Partygo.Parties.Party do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parties" do
    field :age_from, :integer
    field :age_to, :integer
    field :date, :utc_datetime
    field :description, :string
    field :latitude, :float
    field :longitude, :float
    field :geohash, :string
    field :title, :string
    field :assisting_limit, :integer
    field :assisting_count, :integer
    belongs_to :owner, Partygo.Users.User
    many_to_many :assisting, Partygo.Users.User,
      join_through: "assisting_users"

    timestamps()
  end

  @doc false
  def changeset(party, attrs) do
    party
    |> cast(attrs, [:title, :description, :date, :latitude, :longitude, :age_from, :age_to, :assisting_limit])
    |> validate_date()     
    |> put_assoc(:owner, attrs.owner)
    |> put_assoc(:assisting, [])
    |> put_change(:assisting_count, 0)
    |> validate_number(:assisting_limit, greater_than: 0)
    |> validate_assisting()
    |> hash_location()
    |> validate_required([:title, :description, :date, :latitude, :longitude, :owner, :assisting_count, :geohash])
  end

  def edit_changeset(party, attrs) do
    party
    |> cast(attrs, [:description, :date])
    |> validate_date()
    |> validate_required([:description, :date])
  end

  def validate_assisting(changeset) do
    assisting_count = get_field(changeset, :assisting_count)
    changeset
    |> validate_change(:assisting_limit, fn _, value ->
      if is_nil(value) or value >= assisting_count, do: [],
      else: [assisting_limit: "too many people assisting the party!"]
    end)
  end

  def validate_date(changeset) do 
    changeset
    |> validate_change(:date, fn _, value ->
      if DateTime.compare(value, DateTime.utc_now()) == :gt, do: [],
      else: [date: "a party must happen in the future!"]
    end)
  end

  def hash_location(changeset) do
    lat = get_field(changeset, :latitude)
    long = get_field(changeset, :longitude)

    changeset
    |> put_change(:geohash, Geohash.encode(lat, long, 5))
  end
end
