defmodule DiscordBot.WebsockexMock do
  def start_link(_url, mod, state) do
    Agent.start_link(fn -> state end, name: mod)
  end
end
