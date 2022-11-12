defmodule DiscordBot.WebTest do
  use ExUnit.Case, async: true
  doctest DiscordBot.Web
  use TypeCheck.ExUnit
  setup do
    bypass = Bypass.open()
    Application.put_env(:discord_bot, :discord_base_url, endpoint_url(bypass.port))
    bypass |> stub_gateway("wss://example.com/ws")
    {:ok, bypass: bypass}
  end

  spectest DiscordBot.Web

  test "fetch_websocket_url gets a url", %{bypass: bypass} do
    result = DiscordBot.Web.fetch_websocket_url()

    assert result == "wss://example.com/ws?v=10&encoding=json"
  end

  defp stub_gateway(bypass, gateway) do
    Bypass.stub(bypass, "GET", "/gateway", fn (conn = %{req_headers: headers }) ->
      auth_token = Enum.find(headers, fn({key, _}) -> key == "authorization" end)
      assert elem(auth_token, 1) == "Bot bananas"
      Plug.Conn.resp(conn, 200, ~s<{"url": "#{gateway}"}>)
    end)
  end

  test "add_emoji_reaction sends an emoji reaction", %{bypass: bypass} do
    Bypass.expect_once(bypass, "PUT", "/channels/1/messages/2/reactions/%F0%9F%90%94/@me", fn (conn = %{req_headers: headers }) ->
      auth_token = Enum.find(headers, fn({key, _}) -> key == "authorization" end)
      assert elem(auth_token, 1) == "Bot bananas"
      Plug.Conn.resp(conn, 200, ~s<{}>)
    end)

    result = DiscordBot.Web.add_emoji_reaction(channel_id: "1", message_id: "2", emoji: "🐔")
  end

  test "add_emoji_reaction retries if given retry-after", %{bypass: bypass} do
    {:ok, execution_counter} = Agent.start_link(fn -> 0 end)
    ref = self()
    Bypass.stub(bypass, "PUT", "/channels/1/messages/2/reactions/%F0%9F%90%94/@me", fn (conn) ->
      step = Agent.get_and_update(execution_counter, fn state -> {state, state + 1} end)
      conn =
        conn |> Plug.Conn.resp(200, ~s<{}>)
      conn =
        if step == 0 do
          conn |> Plug.Conn.merge_resp_headers([{"retry-after", "1"}])
        else
          send(ref, :second_emoji_reaction)
          conn
        end
      conn
    end)

    result = DiscordBot.Web.add_emoji_reaction(channel_id: "1", message_id: "2", emoji: "🐔")
    assert_receive :second_emoji_reaction, 150
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
