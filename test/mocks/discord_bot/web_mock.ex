defmodule DiscordBot.WebMock do
  @behaviour DiscordBot.WebBehaviour

  @impl true
  def fetch_websocket_url() do
    "ws://example.com/ws"
  end

  @impl true
  def add_emoji_reaction(args = [channel_id: _, message_id: _, emoji: _]) do
    # Send a message so we can assert that this got called.
    send self(), {:add_emoji_reaction, args}
  end
end
