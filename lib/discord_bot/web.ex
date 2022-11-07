defmodule DiscordBot.Web do
  @behaviour DiscordBot.WebBehaviour
  use HTTPoison.Base

  @impl true
  def fetch_websocket_url do
    {:ok, response} = get("/gateway")
    response.body["url"]
  end

  @impl true
  def process_response_body(body) do
    body
    |> Jason.decode!()
  end

  @impl true
  def process_request_url(url) do
    discord_base_url() <> url
  end

  @impl true
  def process_request_headers(headers) do
    headers ++ [Authorization: "Bot #{bot_token()}"]
  end

  defp discord_base_url do
    Application.get_env(:discord_bot, :discord_base_url, "https://discord.com/api/v10")
  end

  defp bot_token do
    Application.fetch_env!(:discord_bot, :bot_token)
  end
end
