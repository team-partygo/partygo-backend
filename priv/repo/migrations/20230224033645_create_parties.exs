defmodule Partygo.Repo.Migrations.CreateParties do
  use Ecto.Migration

  def change do
    create table(:parties) do
      add :age_from, :integer
      add :age_to, :integer
      add :date, :utc_datetime
      add :description, :text
      add :geohash, :string, size: 5
      add :latitude, :float
      add :longitude, :float
      add :title, :string
      add :assisting_limit, :integer
      add :assisting_count, :integer
      add :owner_id, references(:users)

      timestamps()
    end
    create index("parties", [:id, :geohash])

    create table(:assisting_users, primary_key: false) do
      add :party_id, references(:parties, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
