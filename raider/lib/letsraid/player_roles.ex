defmodule LetsRaid.PlayerRoles do
  @moduledoc """
  The PlayerRoles context.
  """

  import Ecto.Query, warn: false
  alias LetsRaid.Repo

  alias LetsRaid.PlayerRoles.PlayerRole

  @doc """
  Returns the list of player_roles.

  ## Examples

      iex> list_player_roles()
      [%PlayerRole{}, ...]

  """
  def list_player_roles do
    Repo.all(PlayerRole)
  end

  @doc """
  Gets a single player_role.

  Raises `Ecto.NoResultsError` if the Player role does not exist.

  ## Examples

      iex> get_player_role!(123)
      %PlayerRole{}

      iex> get_player_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player_role!(id), do: Repo.get!(PlayerRole, id)

  @doc """
  Creates a player_role.

  ## Examples

      iex> create_player_role(%{field: value})
      {:ok, %PlayerRole{}}

      iex> create_player_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player_role(attrs \\ %{}) do
    %PlayerRole{}
    |> PlayerRole.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player_role.

  ## Examples

      iex> update_player_role(player_role, %{field: new_value})
      {:ok, %PlayerRole{}}

      iex> update_player_role(player_role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player_role(%PlayerRole{} = player_role, attrs) do
    player_role
    |> PlayerRole.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a player_role.

  ## Examples

      iex> delete_player_role(player_role)
      {:ok, %PlayerRole{}}

      iex> delete_player_role(player_role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player_role(%PlayerRole{} = player_role) do
    Repo.delete(player_role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player_role changes.

  ## Examples

      iex> change_player_role(player_role)
      %Ecto.Changeset{data: %PlayerRole{}}

  """
  def change_player_role(%PlayerRole{} = player_role, attrs \\ %{}) do
    PlayerRole.changeset(player_role, attrs)
  end
end
