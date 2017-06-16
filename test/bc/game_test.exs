defmodule BC.GameTest do
  use ExUnit.Case, async: true

  alias BC.Game

  setup do
    {:ok, game} = Game.new("1234")
    {:ok, game: game}
  end

  test "new/1", %{game: game} do
    assert game.secret == "1234"
  end

  test "validates secret" do
    assert Game.new("1234567") == :error
    assert Game.new("1123") == :error
  end

  test "guess/2", %{game: game} do
    assert Game.guess(game, "1234") == {:ok, :win}
    assert Game.guess(game, "1256") == {:ok, {2, 0}}
    assert Game.guess(game, "3456") == {:ok, {0, 2}}
    assert Game.guess(game, "1456") == {:ok, {1, 1}}
    assert Game.guess(game, "5678") == {:ok, {0, 0}}
  end
end
