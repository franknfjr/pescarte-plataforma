defmodule ProxyWeb do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [ProxyWeb.Endpoint]
    opts = [strategy: :one_for_one, name: Proxy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ProxyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
