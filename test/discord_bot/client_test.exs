defmodule DiscordBot.ClientTest do
  alias DiscordBot.Client
  use ExUnit.Case
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
      "s" => 1,
      "d" => %{"heartbeat_interval" => 100}
    }
    {:reply, {:text, msg}, state} = Client.handle_frame({:text, Jason.encode!(msg)}, state)
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
      "s" => 1,
      "d" => %{"stuff" => "other stuff"}
    }
    {:ok, state} = Client.handle_frame({:text, Jason.encode!(msg)}, state)
    assert state.ready_event == %{"stuff" => "other stuff"}
  end
end
