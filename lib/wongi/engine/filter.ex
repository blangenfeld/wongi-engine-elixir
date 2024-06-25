defprotocol Wongi.Engine.Filter do
  @moduledoc "Filters tokens based on a predicate."
  @spec pass?(t, Wongi.Engine.Token.t()) :: boolean()
  def pass?(filter, token)
end

defmodule Wongi.Engine.Filter.Common do
  @moduledoc false
  alias Wongi.Engine.DSL.Var

  def resolve(%Var{name: name}, token), do: token[name]

  def resolve(%Var.Access{name: name, keys: keys}, token),
    do: %Var{name: name} |> resolve(token) |> Var.Access.extract(keys)

  def resolve(literal, _), do: literal
end
