defmodule EEx.X.PlainTextEngineTest do
  use ExUnit.Case
  use EEx.X.PlainTextEngine

  test "plain atom" do
    str =  EEx.eval_string(
      "<%= atom %>",
      [atom: to_plain(:api)],
      engine: EEx.X.PlainTextEngine
    )
    assert ":api" == str
  end

  test "string" do
    str =  EEx.eval_string(
      "<%= string %>",
      [string: "test"],
      engine: EEx.X.PlainTextEngine
    )
    assert "test" == str
  end

  test "plain string" do
    str =  EEx.eval_string(
      "<%= string %>",
      [string: to_plain("test")],
      engine: EEx.X.PlainTextEngine
    )
    assert ~s("test") == str
  end

  test "char" do
    str =  EEx.eval_string(
      "<%= char %>",
      [char: 'test'],
      engine: EEx.X.PlainTextEngine
    )
    assert "test" == str
  end

  test "nor support char" do
    str =  EEx.eval_string(
      "<%= char %>",
      [char: to_plain('test')],
      engine: EEx.X.PlainTextEngine
    )
    assert "[116, 101, 115, 116]" == str
  end

  test "plain list" do
    str =  EEx.eval_string(
      "<%= list %>",
      [list: to_plain([a: 1])],
      engine: EEx.X.PlainTextEngine
    )
    assert "[a: 1]" == str
  end

  test "plain map" do
    str =  EEx.eval_string(
      "<%= map %>",
      [map: to_plain(%{a: 1})],
      engine: EEx.X.PlainTextEngine
    )
    assert "%{a: 1}" == str
  end
 

  defstruct name: "aaa", tmp: :tmp
  test "plain struct" do
    str =  EEx.eval_string(
      "<%= struct  %>",
      [struct: to_plain(%__MODULE__{})],
      engine: EEx.X.PlainTextEngine
    )
    assert "%EEx.X.PlainTextEngineTest{name: \"aaa\", tmp: :tmp}" == str
  end

  test "mistakable_list" do
    str =  EEx.eval_string(
      "<%= list %>",
      [list: "[10, 100]"],
      engine: EEx.X.PlainTextEngine
    )
    assert "[10, 100]" == str
  end
  
end
