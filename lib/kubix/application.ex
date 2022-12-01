defmodule Kubix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      # Start the Telemetry supervisor
      KubixWeb.Telemetry,
      # Start the Ecto repository
      Kubix.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Kubix.PubSub},
      # Start Finch
      {Finch, name: Kubix.Finch},
      # Start the Endpoint (http/https)
      KubixWeb.Endpoint,
      # Start a worker by calling: Kubix.Worker.start_link(arg)
      # {Kubix.Worker, arg}
      {Cluster.Supervisor, [topologies, [name: Kubix.ClusterSupervisor]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kubix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KubixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
