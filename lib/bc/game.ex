defmodule BC.Game do
  alias BC.Game

  defstruct secret: nil

  def new(secret) do
    with {:ok, secret} <- validate_format(secret),
         {:ok, secret} <- validate_not_zero_start(secret),
         {:ok, secret} <- validate_unique_digits(secret),
      do: {:ok, %Game{secret: secret}}
  end

  defp validate_unique_digits(secret) do
    digits =
      secret
      |> String.split("", trim: true)
      |> Enum.uniq

    if Enum.count(digits) == 4 do
      {:ok, secret}
    else
      :error
    end
  end

  defp validate_format(secret) do
    if String.match?(secret, ~r/^\d{4}$/) do
      {:ok, secret}
    else
      :error
    end
  end

  defp validate_not_zero_start(secret) do
    case secret do
      "0" <> _rest -> :error
      _ -> {:ok, secret}
    end
  end

  def guess(%Game{secret: secret}, secret) do
    {:ok, :win}
  end

  def guess(%Game{secret: secret}, guess) do
    require IEx
    IEx.pry
    secret = deconstruct_secret(secret)
    guess = deconstruct_secret(guess)

    count_bulls_and_cows(secret, guess, {0, 0})
  end

  defp count_bulls_and_cows(_secret, [], result) do
    {:ok, result}
  end

  defp count_bulls_and_cows(secret, [head | tail], {bulls, cows}) do
    cond do
      bull?(secret, head) ->
        count_bulls_and_cows(secret, tail, {bulls + 1, cows})
      cow?(secret, head) ->
        count_bulls_and_cows(secret, tail, {bulls, cows + 1})
      true ->
        count_bulls_and_cows(secret, tail, {bulls, cows})
    end
  end

  defp bull?(secret, element) do
    Enum.find_value(secret, fn(el) -> el == element end)
  end

  defp cow?(secret, {symbol, _pos}) do
    Enum.find_value(secret, fn({sym, _pos}) -> sym == symbol end)
  end

  defp deconstruct_secret(secret) do
    secret
    |> String.split("", trim: true)
    |> Enum.with_index
  end
end
