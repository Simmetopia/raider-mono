defmodule LetsRaidWeb.Api.PlayerSessionController do
  use LetsRaidWeb, :controller

  alias LetsRaid.Players
  action_fallback LetsRaidWeb.FallbackController

  def create(conn, player_params) do
    with {:ok, %Players.Player{} = player} <- Players.register_player(player_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/session/#{player}")
      |> render(:show, player: player)
    end
  end

  def show(conn, %{"id" => email}) do
    case Players.get_player_by_email(email) do
      nil ->
        {:error, :not_found}

      player ->
        render(conn, :show, player: player)
    end
  end

  def index(conn, _) do
    players = Players.list_players()
    render(conn, :index, players: players)
  end
end
