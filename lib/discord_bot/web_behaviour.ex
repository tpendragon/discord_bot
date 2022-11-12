defmodule DiscordBot.WebBehaviour do
  @callback fetch_websocket_url() :: binary()
  @callback add_emoji_reaction([channel_id: string(), message_id: string(), emoji: string()]) :: any()
end
