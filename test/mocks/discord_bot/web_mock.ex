defmodule DiscordBot.WebMock do
  @behaviour DiscordBot.WebBehaviour

  @impl true
  def fetch_websocket_url() do
    "ws://example.com/ws"
  end
end
