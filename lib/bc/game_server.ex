defmodule BC.GameServer do
  use GenServer

  # Client API

  def start_link(secret) do
    GenServer.start_link(__MODULE__, secret, name: __MODULE__)
  end

  def guess(secret) do
    GenServer.call(__MODULE__, {:guess, secret})
  end

  # Server callbacks

  def init(secret) do
    BC.Game.new(secret)
  end

  def handle_call({:guess, secret}, _from, game) do
    result = BC.Game.guess(game, secret)
    {:reply, result, game}
  end
end
