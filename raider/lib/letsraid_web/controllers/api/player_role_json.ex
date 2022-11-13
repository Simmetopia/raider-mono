defmodule LetsRaidWeb.PlayerRoleJSON do
  alias LetsRaid.PlayerRoles.PlayerRole

  @doc """
  Renders a list of player_roles.
  """
  def index(%{player_roles: player_roles}) do
    %{data: for(player_role <- player_roles, do: data(player_role))}
  end

  @doc """
  Renders a single player_role.
  """
  def show(%{player_role: player_role}) do
    %{data: data(player_role)}
  end

  defp data(%PlayerRole{} = player_role) do
    %{
      id: player_role.id
    }
  end
end
