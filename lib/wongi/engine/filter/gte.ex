defmodule Wongi.Engine.Filter.GTE do
  @moduledoc false
  defstruct [:a, :b]

  def new(a, b) do
    %__MODULE__{a: a, b: b}
  end

  defimpl Wongi.Engine.Filter do
    alias Wongi.Engine.Filter.Common

    def pass?(%@for{a: a, b: b}, token) do
      Comp.greater_or_equal?(Common.resolve(a, token), Common.resolve(b, token))
    end
  end
end
