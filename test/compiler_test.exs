defmodule Wongi.CompilerTest do
  use ExUnit.Case

  import Wongi.Engine.DSL
  import Wongi.Engine

  test "collapses identical join nodes" do
    rule =
      rule(:test,
        forall: [
          has(:a, :b, var(:x)),
          has(var(:x), :d, :e)
        ]
      )

    rete =
      new()
      |> compile(rule)
      |> compile(rule)

    # root, join, join, production; each only linked once

    assert 4 = map_size(rete.beta_table)
    assert 3 = map_size(rete.beta_subscriptions)

    rete.beta_subscriptions
    |> Enum.each(fn {_, children} -> assert [_] = children end)
  end
end
