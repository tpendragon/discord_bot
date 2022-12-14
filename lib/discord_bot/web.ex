defmodule DiscordBot.Web do
  @behaviour DiscordBot.WebBehaviour
  use HTTPoison.Base
  use TypeCheck

  @impl true
  @spec! fetch_websocket_url() :: binary()
  def fetch_websocket_url do
    {:ok, response} = get("/gateway")
    # Best practice to include API version.
    "#{response.body["url"]}?v=10&encoding=json"
  end

  @impl true
  def add_emoji_reaction(channel_id: channel_id, message_id: message_id, emoji: emoji) do
    # /channels/{channel.id}/messages/{message.id}/reactions/{emoji}/@me
    {:ok, response} = put("/channels/#{channel_id}/messages/#{message_id}/reactions/#{URI.encode(emoji)}/@me")
    headers = response.headers |> Map.new
    case Map.fetch(headers, "retry-after") do
      {:ok, val} ->
        val = val |> Integer.parse |> elem(0)
        :timer.apply_after(val*100, DiscordBot.Web, :add_emoji_reaction, [[channel_id: channel_id, message_id: message_id, emoji: emoji]])
      _ ->
    end
  end

  def create_ping_command(application_id: application_id) do
    # "/applications/<my_application_id>/commands"
    {:ok, response} = post("/applications/#{application_id}/commands", %{name: "ping", description: "yes"} |> Jason.encode!, [{"Content-Type", "application/json"}])
  end

  def respond_to_interaction(interaction_id: interaction_id, interaction_token: interaction_token) do
    # /interactions/<interaction_id>/<interaction_token>/callback
    response_json = %{"type" => 4, "data" => %{"content": "Pong!"}}
    url = "/interactions/#{interaction_id}/#{interaction_token}/callback"
    IO.inspect(url)
    {:ok, response} = post(url, Jason.encode!(response_json), [{"Content-Type", "application/json"}])
    IO.inspect(response)
  end

  @impl true
  def process_response_body(body) do
    if(body != "") do
      body
      |> Jason.decode!()
    else
      %{}
    end
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
