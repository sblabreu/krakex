defmodule Krakex.WebSocketClient do
  use WebSockex

  @url "wss://ws.kraken.com"

  def start_link(product_ids \\ []) do
    WebSockex.start_link(@url, __MODULE__, :no_state)
  end

  def subscribe(pid, products) do
    WebSockex.send_frame(pid, subscribtion_frame(products))
  end

  def handle_connect(conn, state) do
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
end
