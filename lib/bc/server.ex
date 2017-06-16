defmodule BC.Server do
  require Logger

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(
      port,
      [:binary, packet: :line, active: false, reuseaddr: true]
    )
    loop_acceptor(socket)
  end

  def loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Task.Supervisor.start_child(:players_supervisor, fn ->
      BC.Player.play(client)
    end)
    loop_acceptor(socket)
  end
end
