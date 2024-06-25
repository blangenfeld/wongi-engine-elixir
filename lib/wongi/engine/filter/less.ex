defmodule Wongi.Engine.Filter.Less do
  @moduledoc false
  defstruct [:a, :b]

  def new(a, b) do
    %__MODULE__{a: a, b: b}
  end

  defimpl Wongi.Engine.Filter do
    alias Wongi.Engine.Filter.Common

    def pass?(%@for{a: a, b: b}, token) do
      with [a, b] <- Enum.map([a, b], &Common.resolve(&1, token)),
           true <- Enum.all?([a, b]) do
        Comp.less_than?(a, b)
      end
    end
  end
end
