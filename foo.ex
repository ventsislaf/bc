defmodule Foo do
  def foo do
    bar
  end

  defp bar do

  end
end

Foo.foo
Foo.bar => error
