defmodule DiscordBot.WebTest do
  use ExUnit.Case, async: true
  doctest DiscordBot.Web
  setup do
    bypass = Bypass.open()
    Application.put_env(:discord_bot, :discord_base_url, endpoint_url(bypass.port))
    {:ok, bypass: bypass}
  end

  test "fetch_websocket_url gets a url", %{bypass: bypass} do
    bypass |> stub_gateway("wss://example.com/ws")

    result = DiscordBot.Web.fetch_websocket_url()
    assert result == "wss://example.com/ws"
  end

  defp stub_gateway(bypass, gateway) do
    Bypass.expect_once(bypass, "GET", "/gateway", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"url": "#{gateway}"}>)
    end)
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
