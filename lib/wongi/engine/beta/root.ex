defmodule Wongi.Engine.Beta.Root do
  @moduledoc false
  alias Wongi.Engine.Rete
  alias Wongi.Engine.Token
  defstruct [:ref]

  def new do
    %__MODULE__{
      ref: make_ref()
    }
  end

  def seed(beta, rete) do
    token = Token.new(beta, [], nil)

    rete
    |> Rete.add_token(token)
  end

  defimpl Wongi.Engine.Beta do
    alias Wongi.Engine.Beta

    def ref(%@for{ref: ref}) do
      ref
    end

    def parent_ref(_), do: nil

    def seed(%@for{} = root, beta, rete) do
      Rete.tokens(rete, root)
      |> Enum.reduce(rete, fn token, rete ->
        Beta.beta_activate(beta, Token.new(beta, [token], nil), rete)
      end)
    end

    def equivalent?(
          %@for{},
          %@for{},
          _rete
        ),
        do: true

    def equivalent?(_, _, _), do: false

    def alpha_activate(_, _, _), do: raise("Root node cannot be activated")
    def alpha_deactivate(_, _, _), do: raise("Root node cannot be deactivated")

    def beta_activate(%@for{ref: _ref}, _token, rete) do
      rete
    end

    def beta_deactivate(%@for{ref: _ref}, _token, rete) do
      rete
    end
  end
end