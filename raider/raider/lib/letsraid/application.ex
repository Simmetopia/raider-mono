defmodule LetsRaid.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LetsRaidWeb.Telemetry,
      # Start the Ecto repository
      LetsRaid.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LetsRaid.PubSub},
      # Start Finch
      {Finch, name: LetsRaid.Finch},
      # Start the Endpoint (http/https)
      LetsRaidWeb.Endpoint
      # Start a worker by calling: LetsRaid.Worker.start_link(arg)
      # {LetsRaid.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LetsRaid.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LetsRaidWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
