defmodule Wongi.Engine.DSL.Var do
  @moduledoc "Variable declaration."
  defstruct [:name, :keys]

  @type key() :: atom() | binary() | non_neg_integer()
  @type t() :: %__MODULE__{name: atom(), keys: list(key())}

  @doc false
  def new(name, keys \\ []) when is_atom(name) and is_list(keys) do
    %__MODULE__{
      name: name,
      keys: keys
    }
  end

  def extract_path(value, []), do: value
  def extract_path(nil, _keys), do: nil

  def extract_path(%{} = map, [h | t] = _keys) when is_atom(h) or is_binary(h),
    do: Map.get(map, h) |> extract_path(t)

  def extract_path(list, [h | t] = _keys) when is_list(list) and is_integer(h),
    do: Enum.at(list, h) |> extract_path(t)
end
