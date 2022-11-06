import Config
if config_env() == :dev || config_env() == :test do
  Dotenv.load!
end

# These are accessible in code like this:
# Application.fetch_env!(:discord_bot, :bot_token)
config :discord_bot,
  bot_token: System.get_env("BOT_TOKEN")
