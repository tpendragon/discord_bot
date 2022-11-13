defmodule DiscordBot.Client do
  use WebSockex

  def start_link(state = %{url: url, token: _token, message_handler: _}) do
    state =
      state |>
        put_in([:sequence], 0)
    websocket_client().start_link(url, __MODULE__, state)
  end

  defp websocket_client() do
    Application.fetch_env!(:discord_bot, :websocket_client)
  end

  def handle_frame({:text, msg}, state) do
    handle_message(msg, state)
  end

  defp handle_message(msg, state) when is_binary(msg) do
    msg = Jason.decode!(msg)
    state = update_sequence(msg, state)
    handle_message(msg, state)
  end
  # Hello message
  defp handle_message(%{"op" => 10, "d" => %{"heartbeat_interval" => _heartbeat}}, state) do
    identify(state)
  end
  # Ready event - cache it
  defp handle_message(%{"op" => 0, "t" => "READY", "d" => msg}, state) do
    state =
      state |> put_in([:ready_event], msg)
    {:ok, state}
  end
  defp handle_message(msg, state = %{message_handler: message_handler}) do
    try do
      message_handler.handle_message(msg)
    rescue
      e in FunctionClauseError -> IO.puts "Unhandled message - #{inspect msg}"
    end
    {:ok, state}
  end

  defp identify(state = %{token: token}) do
    identify_event =
      %{
        "op" => 2,
        "d" => %{
          "token" => token,
          "intents" => 34312,
          "properties" => %{
            "os" => "linux",
            "browser" => "discordbot",
            "device" => "discordbot"
          }
        }
      }
    identify_event = Jason.encode!(identify_event)
    {:reply, {:text, identify_event}, state}
  end

  # Update sequence
  defp update_sequence(%{"s" => nil}, state), do: state
  defp update_sequence(%{"s" => s}, state = %{sequence: sequence}) when s > sequence do
    state |> put_in([:sequence], s)
  end
  defp update_sequence(_msg, state), do: state
end
