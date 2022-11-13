defmodule LetsRaidWeb.RoleControllerTest do
  use LetsRaidWeb.ConnCase

  import LetsRaid.PlayersFixtures

  alias LetsRaid.Players.Role

  @create_attrs %{
    role: "some role",
    spec: "some spec"
  }
  @update_attrs %{
    role: "some updated role",
    spec: "some updated spec"
  }
  @invalid_attrs %{role: nil, spec: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all roles", %{conn: conn} do
      conn = get(conn, ~p"/api/roles")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create role" do
    test "renders role when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/roles", role: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/roles/#{id}")

      assert %{
               "id" => ^id,
               "role" => "some role",
               "spec" => "some spec"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/roles", role: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update role" do
    setup [:create_role]

    test "renders role when data is valid", %{conn: conn, role: %Role{id: id} = role} do
      conn = put(conn, ~p"/api/roles/#{role}", role: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/roles/#{id}")

      assert %{
               "id" => ^id,
               "role" => "some updated role",
               "spec" => "some updated spec"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, role: role} do
      conn = put(conn, ~p"/api/roles/#{role}", role: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete role" do
    setup [:create_role]

    test "deletes chosen role", %{conn: conn, role: role} do
      conn = delete(conn, ~p"/api/roles/#{role}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/roles/#{role}")
      end
    end
  end

  defp create_role(_) do
    role = role_fixture()
    %{role: role}
  end
end
