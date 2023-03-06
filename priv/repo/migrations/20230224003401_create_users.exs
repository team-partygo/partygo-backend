defmodule Partygo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :tag, :string
      add :name, :string
      add :dob, :date
      add :sex, :string

      timestamps()
    end

    create unique_index(:users, [:tag])

    create table(:uuids) do
      add :uuid_source, :string, length: 16
      add :uuid, :string
      add :email, :string
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:uuids, [:uuid_source, :uuid])
  end
end
