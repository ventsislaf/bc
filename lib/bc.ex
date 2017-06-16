defmodule BC do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Task.Supervisor, [[name: :players_supervisor]]),
      worker(BC.GameServer, ["1234"]),
      worker(Task, [BC.Server, :accept, [4040]])
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: BC.Supervisor)
  end
end
