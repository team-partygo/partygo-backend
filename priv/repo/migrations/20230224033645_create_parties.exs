defmodule Partygo.Repo.Migrations.CreateParties do
  use Ecto.Migration

  def change do
    create table(:parties) do
      add :age_from, :integer
      add :age_to, :integer
      add :date, :utc_datetime
      add :description, :text
      add :latitude, :decimal
      add :longitude, :decimal
      add :title, :string
      add :owner_id, references(:users)

      timestamps()
    end

    create table(:assisting_users, primary_key: false) do
      add :party_id, references(:parties, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
