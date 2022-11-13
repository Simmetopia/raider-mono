defmodule LetsRaid.PlayerRolesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LetsRaid.PlayerRoles` context.
  """

  @doc """
  Generate a player_role.
  """
  def player_role_fixture(attrs \\ %{}) do
    {:ok, player_role} =
      attrs
      |> Enum.into(%{

      })
      |> LetsRaid.PlayerRoles.create_player_role()

    player_role
  end
end
