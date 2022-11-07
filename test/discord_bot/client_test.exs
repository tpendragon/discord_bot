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
end
