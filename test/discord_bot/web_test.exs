defmodule DiscordBot.WebTest do
  use ExUnit.Case
  doctest DiscordBot.Web
  use TypeCheck.ExUnit
  setup do
    bypass = Bypass.open()
    Application.put_env(:discord_bot, :discord_base_url, endpoint_url(bypass.port))
    bypass |> stub_gateway("wss://example.com/ws")
    {:ok, bypass: bypass}
  end

  spectest DiscordBot.Web

  test "fetch_websocket_url gets a url" do
    result = DiscordBot.Web.fetch_websocket_url()
    assert result == "wss://example.com/ws?v=10&encoding=json"
  end

  defp stub_gateway(bypass, gateway) do
    Bypass.expect(bypass, "GET", "/gateway", fn (conn = %{req_headers: headers }) ->
      auth_token = Enum.find(headers, fn({key, _}) -> key == "authorization" end)
      assert elem(auth_token, 1) == "Bot bananas"
      Plug.Conn.resp(conn, 200, ~s<{"url": "#{gateway}"}>)
    end)
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
