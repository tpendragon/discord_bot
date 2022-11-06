defmodule DiscordBot.Web do
  use HTTPoison.Base

  def fetch_websocket_url do
    {:ok, response} = get("/gateway")
    response.body["url"]
  end

  def process_response_body(body) do
    body
    |> Jason.decode!()
  end

  def process_request_url(url) do
    discord_base_url() <> url
  end

  def process_request_headers(headers) do
    headers ++ [Authorization: "Bot #{bot_token()}"]
  end

  defp discord_base_url do
    "https://discord.com/api/v10"
  end

  defp bot_token do
    Application.fetch_env!(:discord_bot, :bot_token)
  end
end
