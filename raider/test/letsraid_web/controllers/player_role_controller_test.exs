defmodule LetsRaidWeb.PlayerRoleControllerTest do
  use LetsRaidWeb.ConnCase

  import LetsRaid.PlayerRolesFixtures

  alias LetsRaid.PlayerRoles.PlayerRole

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all player_roles", %{conn: conn} do
      conn = get(conn, ~p"/api/player_roles")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create player_role" do
    test "renders player_role when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/player_roles", player_role: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/player_roles/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/player_roles", player_role: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update player_role" do
    setup [:create_player_role]

    test "renders player_role when data is valid", %{conn: conn, player_role: %PlayerRole{id: id} = player_role} do
      conn = put(conn, ~p"/api/player_roles/#{player_role}", player_role: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/player_roles/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, player_role: player_role} do
      conn = put(conn, ~p"/api/player_roles/#{player_role}", player_role: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete player_role" do
    setup [:create_player_role]

    test "deletes chosen player_role", %{conn: conn, player_role: player_role} do
      conn = delete(conn, ~p"/api/player_roles/#{player_role}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/player_roles/#{player_role}")
      end
    end
  end

  defp create_player_role(_) do
    player_role = player_role_fixture()
    %{player_role: player_role}
  end
end
