defmodule Wongi.Engine.AssignTest do
  use Wongi.TestCase

  test "assigns a static value by itself" do
    {rete, ref} =
      new()
      |> compile_and_get_ref(
        rule(
          forall: [
            assign(:x, 42)
          ]
        )
      )

    assert [token] = rete |> tokens(ref) |> Enum.to_list()
    assert 42 = token[:x]
  end

  test "assigns a value from a var" do
    {rete, ref} =
      new()
      |> compile_and_get_ref(
        rule(
          forall: [
            assign(:x, 42),
            assign(:y, var(:x))
          ]
        )
      )

    assert [token] = rete |> tokens(ref) |> Enum.to_list()
    assert 42 = token[:y]
  end

  test "assigns a value at a path inside a var value" do
    {rete, ref} =
      new()
      |> compile_and_get_ref(
        rule(
          forall: [
            assign(:x, [1, 2, 3]),
            assign(:y, var(:x, 2))
          ]
        )
      )

    assert [token] = rete |> tokens(ref) |> Enum.to_list()
    assert 3 = token[:y]
  end

  test "assigns a calculated value (nullary callback)" do
    {rete, ref} =
      new()
      |> compile_and_get_ref(
        rule(
          forall: [
            assign(:x, fn -> 42 end)
          ]
        )
      )

    assert [token] = rete |> tokens(ref) |> Enum.to_list()
    assert 42 = token[:x]
  end

  test "assigns a value calculated from the token (unary callback)" do
    {rete, ref} =
      new()
      |> compile_and_get_ref(
        rule(
          forall: [
            has(:x, :y, var(:z)),
            assign(:x, &(&1[:z] * 2))
          ]
        )
      )

    rete = rete |> assert(:x, :y, 21)

    assert [token] = rete |> tokens(ref) |> Enum.to_list()
    assert 42 = token[:x]
  end

  test "assigns a value calculated from the token (binary callback)" do
    {rete, ref} =
      new()
      |> compile_and_get_ref(
        rule(
          forall: [
            has(:x, :y, var(:z)),
            assign(:x, fn token, _rete -> token[:z] * 2 end)
          ]
        )
      )

    rete = rete |> assert(:x, :y, 21)

    assert [token] = rete |> tokens(ref) |> Enum.to_list()
    assert 42 = token[:x]
  end

  test "assigned value can be matched on" do
    {rete, ref} =
      new()
      |> compile_and_get_ref(
        rule(
          forall: [
            assign(:x, 42),
            has(var(:x), :y, :z)
          ]
        )
      )

    assert [] = rete |> tokens(ref) |> Enum.to_list()

    rete = rete |> assert(42, :y, :z)
    assert [token] = rete |> tokens(ref) |> Enum.to_list()
    assert 42 = token[:x]
  end
end
