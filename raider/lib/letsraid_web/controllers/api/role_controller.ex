defmodule LetsRaidWeb.RoleController do
  use LetsRaidWeb, :controller

  alias LetsRaid.Players
  alias LetsRaid.Players.Role

  action_fallback LetsRaidWeb.FallbackController

  def index(conn, _params) do
    roles = Players.list_roles()
    render(conn, :index, roles: roles)
  end

  def create(conn, %{"role" => role_params}) do
    with {:ok, %Role{} = role} <- Players.create_role(role_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/roles/#{role}")
      |> render(:show, role: role)
    end
  end

  def show(conn, %{"id" => id}) do
    role = Players.get_role!(id)
    render(conn, :show, role: role)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = Players.get_role!(id)

    with {:ok, %Role{} = role} <- Players.update_role(role, role_params) do
      render(conn, :show, role: role)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Players.get_role!(id)

    with {:ok, %Role{}} <- Players.delete_role(role) do
      send_resp(conn, :no_content, "")
    end
  end
end
