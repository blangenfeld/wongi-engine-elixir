defmodule Wongi.Engine.DSL.Var do
  @moduledoc "Variable declaration."
  defstruct [:name]

  @type t() :: %__MODULE__{name: atom()}

  @doc false
  def new(name) when is_atom(name) do
    %__MODULE__{
      name: name
    }
  end

  defmodule Access do
    @moduledoc false
    defstruct [:name, :keys]

    @type t() :: %__MODULE__{name: atom(), keys: list(atom() | binary() | non_neg_integer())}

    @doc false
    def new(name, keys \\ []) when is_atom(name) do
      %__MODULE__{
        name: name,
        keys: keys
      }
    end

    def extract(value, []), do: value
    def extract(nil, _keys), do: nil

    def extract(%{} = map, [h | t]) when is_atom(h) or is_binary(h),
      do: Map.get(map, h) |> extract(t)

    def extract(list, [h | t]) when is_list(list) and is_integer(h) do
      Enum.at(list, h) |> extract(t)
    end
  end
end
