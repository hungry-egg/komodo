defmodule PhxExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhxExampleWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:phx_example, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhxExample.PubSub},
      # Start a worker by calling: PhxExample.Worker.start_link(arg)
      # {PhxExample.Worker, arg},
      # Start to serve requests, typically the last entry
      PhxExampleWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhxExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhxExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
