defmodule DiscordBot.ClientTest do
  alias DiscordBot.Client
  use ExUnit.Case, async: true
  doctest DiscordBot.Web
  use TypeCheck.ExUnit

  test "handle_frame stores updated s values" do
    state = Agent.get(DiscordBot.Client, & &1)
    {:ok, new_state} = Client.handle_frame({:text, Jason.encode!(%{"s" => 1})}, state)

    assert new_state.sequence == 1
  end

  test "identifies after hello event" do
    state = Agent.get(DiscordBot.Client, & &1)
    msg = %{
      "op" => 10,
      "s" => nil,
      "d" => %{"heartbeat_interval" => 100}
    }
    {:reply, {:text, msg}, _state} = Client.handle_frame({:text, Jason.encode!(msg)}, state)
    msg = Jason.decode!(msg)
    assert msg["op"] == 2
    assert msg["d"]["token"] == "bananas"
    assert msg["d"]["intents"] == 34312
  end

  test "caches ready event" do
    state = Agent.get(DiscordBot.Client, & &1)
    msg = %{
      "op" => 0,
      "t" => "READY",
      "d" => %{"stuff" => "other stuff"}
    }
    {:ok, state} = Client.handle_frame({:text, Jason.encode!(msg)}, state)
    assert state.ready_event == %{"stuff" => "other stuff"}
  end

  test "creates emojis when saying 'guess what'" do
    state = Agent.get(DiscordBot.Client, & &1)
    msg = %{
      "t" => "MESSAGE_CREATE",
      "s" => 1,
      "d" => %{
        "channel_id" => "12",
        "id" => "30",
        "content" => "Hey Guess WhAt"
      }
    }
    {:ok, _state} = Client.handle_frame({:text, Jason.encode!(msg)}, state)
    assert_receive {:add_emoji_reaction, [channel_id: _, message_id: _, emoji: "🐔"]}
    assert_receive {:add_emoji_reaction, [channel_id: _, message_id: _, emoji: "🍑"]}
  end
end
