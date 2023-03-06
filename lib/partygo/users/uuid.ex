defmodule Partygo.Users.UUID do
  use Ecto.Schema
  import Ecto.Changeset

  schema "uuids" do
    field :uuid_source, Ecto.Enum, values: [:google]
    field :uuid, :string
    field :email, :string
    belongs_to :user, Partygo.Users.User
  end

  @doc false
  def changeset(uuid, attrs) do
    uuid
    |> cast(attrs, [:uuid_source, :uuid, :email])
  end
end
