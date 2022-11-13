defmodule LetsRaid.Players.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :role, :string
    field :spec, :string

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:role, :spec])
    |> validate_required([:role, :spec])
  end
end
