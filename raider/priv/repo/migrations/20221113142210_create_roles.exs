defmodule LetsRaid.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :role, :string
      add :spec, :string

      timestamps()
    end
  end
end
