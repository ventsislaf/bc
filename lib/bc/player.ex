defmodule BC.Player do
  def play(socket) do
    case read_line(socket) do
      {:ok, data} ->
        case BC.GameServer.guess(data) do
          {:ok, :win} ->
            write_line(socket, "You won!")
            :gen_tcp.close(socket)
          {:ok, {b, c}} ->
            msg = "#{data} : #{b} #{bulls(b)} и #{c} #{cows(c)}"
            write_line(socket, msg)
          :error ->
            write_line(socket, "Invalid format")
        end
        play(socket)
      {:error, _} ->
        :gen_tcp.close(socket)
    end
  end

  defp bulls(number) do
    if number == 1 do
      "бик"
    else
      "бикa"
    end
  end

  defp cows(number) do
    if number == 1 do
      "крава"
    else
      "крави"
    end
  end

  defp read_line(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        {:ok, String.trim(data)}
      {:error, _reason} = error ->
        error
    end
  end

  defp write_line(socket, msg) do
    :gen_tcp.send(socket, msg <> "\n")
  end
end
