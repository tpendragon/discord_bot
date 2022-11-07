Mox.defmock(DiscordBot.WebMock, for: DiscordBot.WebBehaviour)
Application.put_env(:discord_bot, :http_client, DiscordBot.WebMock)
ExUnit.start()
