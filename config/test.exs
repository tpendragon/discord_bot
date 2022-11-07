import Config

config :discord_bot,
  http_client: DiscordBot.WebMock,
  websocket_client: DiscordBot.WebsockexMock
