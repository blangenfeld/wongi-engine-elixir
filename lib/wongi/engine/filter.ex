defprotocol Wongi.Engine.Filter do
  @moduledoc "Filters tokens based on a predicate."
  @spec pass?(t, Wongi.Engine.Token.t()) :: boolean()
  def pass?(filter, token)
end

defmodule Wongi.Engine.Filter.Common do
  @moduledoc false
  alias Wongi.Engine.DSL.Var
  def resolve(%Var{name: name, keys: keys}, token), do: token[{name, keys}]
  def resolve(literal, _), do: literal
end
