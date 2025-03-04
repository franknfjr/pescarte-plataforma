import Config

config :timex, timezone: System.get_env("TIMEZONE", "America/Sao_Paulo")

if System.get_env("PHX_SERVER") do
  config :proxy_web, ProxyWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  database_opts = [
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6
  ]

  config :database, Database.EscritaRepo, database_opts
  config :database, Database.LeituraRepo, database_opts

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "SECRET_KEY_BASE not available"

  config :proxy_web, ProxyWeb.Endpoint,
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: secret_key_base

  if System.get_env("UENF_SERVER") do
    config :proxy_web, ProxyWeb.Endpoint, url: [host: "pescarte.uenf.br", port: 8080]
  end
end
