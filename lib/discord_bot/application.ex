defmodule DiscordBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: DiscordBot.Worker.start_link(arg)
      # {DiscordBot.Worker, arg}
      { DiscordBot.Client, %{ url: Application.fetch_env!(:discord_bot, :http_client).fetch_websocket_url() , token: Application.fetch_env!(:discord_bot, :bot_token), message_handler: DiscordBot.MessageHandler} }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DiscordBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
