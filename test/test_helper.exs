Mox.defmock(DiscordBot.WebMock, for: DiscordBot.WebBehaviour)
Application.put_env(:discord_bot, :http_client, DiscordBot.WebMock)
defmodule Pry do
  defmacro __using__(_opts) do
    quote do
      require IEx
      IEx.pry()
    end
  end
end

ExUnit.start(timeout: :infinity)
