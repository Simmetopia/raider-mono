defmodule LetsRaid.PlayerRolesTest do
  use LetsRaid.DataCase

  alias LetsRaid.PlayerRoles

  describe "player_roles" do
    alias LetsRaid.PlayerRoles.PlayerRole

    import LetsRaid.PlayerRolesFixtures

    @invalid_attrs %{}

    test "list_player_roles/0 returns all player_roles" do
      player_role = player_role_fixture()
      assert PlayerRoles.list_player_roles() == [player_role]
    end

    test "get_player_role!/1 returns the player_role with given id" do
      player_role = player_role_fixture()
      assert PlayerRoles.get_player_role!(player_role.id) == player_role
    end

    test "create_player_role/1 with valid data creates a player_role" do
      valid_attrs = %{}

      assert {:ok, %PlayerRole{} = player_role} = PlayerRoles.create_player_role(valid_attrs)
    end

    test "create_player_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PlayerRoles.create_player_role(@invalid_attrs)
    end

    test "update_player_role/2 with valid data updates the player_role" do
      player_role = player_role_fixture()
      update_attrs = %{}

      assert {:ok, %PlayerRole{} = player_role} = PlayerRoles.update_player_role(player_role, update_attrs)
    end

    test "update_player_role/2 with invalid data returns error changeset" do
      player_role = player_role_fixture()
      assert {:error, %Ecto.Changeset{}} = PlayerRoles.update_player_role(player_role, @invalid_attrs)
      assert player_role == PlayerRoles.get_player_role!(player_role.id)
    end

    test "delete_player_role/1 deletes the player_role" do
      player_role = player_role_fixture()
      assert {:ok, %PlayerRole{}} = PlayerRoles.delete_player_role(player_role)
      assert_raise Ecto.NoResultsError, fn -> PlayerRoles.get_player_role!(player_role.id) end
    end

    test "change_player_role/1 returns a player_role changeset" do
      player_role = player_role_fixture()
      assert %Ecto.Changeset{} = PlayerRoles.change_player_role(player_role)
    end
  end
end
