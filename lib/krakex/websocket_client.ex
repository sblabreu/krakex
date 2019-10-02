defmodule Krakex.WebSocketClient do
  use WebSockex

  @url "wss://ws.kraken.com"

  def start_link(products \\ []) do
    {:ok, pid} = WebSockex.start_link(@url, __MODULE__, :no_state)
    subscribe(pid, products)
    {:ok, pid}
  end

  def handle_connect(_conn, state) do
    {:ok, state}
  end

  def handle_disconnect(_conn, state) do
    {:ok, state}
  end

  def handle_frame({:text, msg}, state) do
    case Jason.decode(msg) do
      {:ok, decoded} ->
        IO.inspect(msg)

        {:ok, decoded}

      {:error, %Jason.DecodeError{}} ->
        {:error, {:invalid, msg}}
    end

    {:ok, state}
  end

  def subscribe(pid, pairs) do
    frame = subscription_frame(pairs)
    WebSockex.send_frame(pid, frame)
  end

  def unsubscribe(pid, pairs) do
    frame = subscription_frame(pairs)
    WebSockex.send_frame(pid, frame)
  end

  defp subscription_frame(pairs) do
    payload = %{
      event: "subscribe",
      pair: pairs,
      subscription: %{
        name: "ticker"
      }
    }

    {:text, Jason.encode!(payload)}
  end
end
