defmodule Partygo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uid, :string
      add :tag, :string
      add :name, :string
      add :dob, :date
      add :sex, :string
      add :email, :string

      timestamps()
    end

    create unique_index(:users, [:tag])
  end
end
