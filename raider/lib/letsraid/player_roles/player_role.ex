defmodule LetsRaid.PlayerRoles.PlayerRole do
  use Ecto.Schema
  import Ecto.Changeset

  schema "player_roles" do

    field :user_id, :id
    field :role_id, :id

    timestamps()
  end

  @doc false
  def changeset(player_role, attrs) do
    player_role
    |> cast(attrs, [])
    |> validate_required([])
  end
end
