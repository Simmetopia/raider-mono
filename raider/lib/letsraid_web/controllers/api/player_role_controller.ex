defmodule LetsRaidWeb.PlayerRoleController do
  use LetsRaidWeb, :controller

  alias LetsRaid.PlayerRoles
  alias LetsRaid.PlayerRoles.PlayerRole

  action_fallback LetsRaidWeb.FallbackController

  def index(conn, _params) do
    player_roles = PlayerRoles.list_player_roles()
    render(conn, :index, player_roles: player_roles)
  end

  def create(conn, %{"player_role" => player_role_params}) do
    with {:ok, %PlayerRole{} = player_role} <- PlayerRoles.create_player_role(player_role_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/player_roles/#{player_role}")
      |> render(:show, player_role: player_role)
    end
  end

  def show(conn, %{"id" => id}) do
    player_role = PlayerRoles.get_player_role!(id)
    render(conn, :show, player_role: player_role)
  end

  def update(conn, %{"id" => id, "player_role" => player_role_params}) do
    player_role = PlayerRoles.get_player_role!(id)

    with {:ok, %PlayerRole{} = player_role} <- PlayerRoles.update_player_role(player_role, player_role_params) do
      render(conn, :show, player_role: player_role)
    end
  end

  def delete(conn, %{"id" => id}) do
    player_role = PlayerRoles.get_player_role!(id)

    with {:ok, %PlayerRole{}} <- PlayerRoles.delete_player_role(player_role) do
      send_resp(conn, :no_content, "")
    end
  end
end
