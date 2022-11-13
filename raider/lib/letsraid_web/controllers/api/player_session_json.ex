defmodule LetsRaidWeb.Api.PlayerSessionJSON do
  alias LetsRaid.Players.Player

  @doc """
  Renders a list of player_roles.
  """
  def index(%{players: players}) do
    %{data: for(player <- players, do: data(player))}
  end

  @doc """
  Renders a single player_role.
  """
  def show(%{player: player}) do
    %{data: data(player)}
  end

  defp data(%Player{} = player_role) do
    %{
      id: player_role.id,
      email: player_role.email
    }
  end
end
