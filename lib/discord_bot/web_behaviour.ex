defmodule DiscordBot.WebBehaviour do
  @callback fetch_websocket_url() :: binary()
end
