defmodule LetsRaidWeb.RoleJSON do
  alias LetsRaid.Players.Role

  @doc """
  Renders a list of roles.
  """
  def index(%{roles: roles}) do
    %{data: for(role <- roles, do: data(role))}
  end

  @doc """
  Renders a single role.
  """
  def show(%{role: role}) do
    %{data: data(role)}
  end

  defp data(%Role{} = role) do
    %{
      id: role.id,
      role: role.role,
      spec: role.spec
    }
  end
end
