defmodule Wongi.Engine.Filter.GTE do
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
        Comp.greater_or_equal?(a, b)
      end
    end
  end
end
