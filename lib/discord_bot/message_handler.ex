defmodule DiscordBot.MessageHandler do
  def handle_message(%{"t" => "MESSAGE_CREATE", "d" => %{"channel_id" => channel_id, "id" => message_id, "content" => message}}) do
    handle_created_message(channel_id, message_id, message)
  end
  def handle_message(msg = %{"t" => "INTERACTION_CREATE", "d" => %{"id" => interaction_id, "data" => %{"name" => "ping"}, "token" => interaction_token}}) do
    IO.inspect(msg)
    IO.inspect(interaction_id)
    IO.inspect(interaction_token)
    http_client().respond_to_interaction(interaction_id: interaction_id, interaction_token: interaction_token)
  end

  defp handle_created_message(channel_id, message_id, message) do
    message = String.downcase(message)
    if(String.contains?(message, "guess what")) do
      http_client().add_emoji_reaction(channel_id: channel_id, message_id: message_id, emoji: "🐔")
      http_client().add_emoji_reaction(channel_id: channel_id, message_id: message_id, emoji: "🍑")
    end
  end

  defp http_client() do
    Application.fetch_env!(:discord_bot, :http_client)
  end
end
