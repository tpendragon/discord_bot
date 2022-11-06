import Config
# These are accessible in code like this:
# Application.fetch_env!(:discord_bot, :bot_token)
config :discord_bot,
  http_client: HTTPoison
