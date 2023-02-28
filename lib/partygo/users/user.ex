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

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:uid, :tag, :name, :dob, :sex, :email])
    |> validate_required([:uid, :tag, :name, :dob, :email])
    |> unique_constraint(:tag)
  end
end
