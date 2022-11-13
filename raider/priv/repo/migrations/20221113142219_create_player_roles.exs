defmodule LetsRaid.Repo.Migrations.CreatePlayerRoles do
  use Ecto.Migration

  def change do
    create table(:player_roles) do
      add :player_id, references(:players, on_delete: :nothing)
      add :role_id, references(:roles, on_delete: :nothing)

      timestamps()
    end

    create index(:player_roles, [:player_id])
    create index(:player_roles, [:role_id])
  end
end
