defmodule DiscordBot.WebTest do
  use ExUnit.Case, async: true
  use Mimic
  doctest DiscordBot.Web

  defp stub_body(body) do
    :hackney
    |> stub(:body, fn _, _ ->
      {:ok, body}
    end)
  end

  test "fetch_websocket_url gets a url" do
    stub_body('{"url": "wss://example.com/ws"}')

    result = DiscordBot.Web.fetch_websocket_url()
    assert result == "wss://example.com/ws"
  end
end
