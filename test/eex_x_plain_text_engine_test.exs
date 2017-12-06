defmodule EEx.X.PlainTextEngineTest do
  use ExUnit.Case
  use EEx.X.PlainTextEngine

  test "plain atom" do
    str =  EEx.eval_string(
      "<%= @atom %>",
      [assigns: [atom: :api]],
      engine: EEx.X.PlainTextEngine
    )
    assert ":api" == str

    str =  EEx.eval_string(
      "<%= atom %>",
      [atom: :api],
      engine: EEx.X.PlainTextEngine
    )
    assert ":api" == str

  end

  test "plain function in template" do
    str =  EEx.eval_string(
      "<%= @atom |> @as_original.() %>",
      [assigns: [atom: :api, as_original: &as_original(&1) ]],
      engine: EEx.X.PlainTextEngine
    )
    assert "api" == str
  end

  test "plain string" do
    str =  EEx.eval_string(
      "<%= @string %>",
      [assigns: [string: "test"]],
      engine: EEx.X.PlainTextEngine
    )
    assert ~s("test") == str
  end

  test "char (EEx default engine)" do
    str =  EEx.eval_string(
      "<%= @char %>",
      [assigns: [char: as_original('test')]],
      engine: EEx.X.PlainTextEngine
    )
    assert "test" == str
  end

  test "nor support char" do
    str =  EEx.eval_string(
      "<%= @char %>",
      [assigns: [char: 'test']],
      engine: EEx.X.PlainTextEngine
    )
    assert "[116, 101, 115, 116]" == str
  end

  test "plain list" do
    str =  EEx.eval_string(
      "<%= @list %>",
      [assigns: [list: [a: 1]]],
      engine: EEx.X.PlainTextEngine
    )
    assert "[a: 1]" == str
  end

  test "plain map" do
    str =  EEx.eval_string(
      "<%= @map %>",
      [assigns: [map: %{a: 1}]],
      engine: EEx.X.PlainTextEngine
    )
    assert "%{a: 1}" == str
  end
 

  defstruct name: "aaa", tmp: :tmp
  test "plain struct" do
    str =  EEx.eval_string(
      "<%= @struct  %>",
      [assigns: [struct: %__MODULE__{}]],
      engine: EEx.X.PlainTextEngine
    )
    assert "%EEx.X.PlainTextEngineTest{name: \"aaa\", tmp: :tmp}" == str
  end

  test "mistakable_list" do
    str =  EEx.eval_string(
      "<%= @list %>",
      [assigns: [list: [10, 100]]],
      engine: EEx.X.PlainTextEngine
    )
    assert "[10, 100]" == str
  end



  test "nest" do
    str =  EEx.eval_string(
      "<%= @p.cc %>",
      [assigns: [p: %{cc: "aaa"}]],
      engine: EEx.X.PlainTextEngine
    )
    assert ~s("aaa") == str
  end


  test "if" do
    str =  EEx.eval_string(
      "<%= if true do %><%= @bar %><%= end %>",
      [assigns: [bar: "baz"]],
      engine: EEx.X.PlainTextEngine
    )
    assert ~s("baz") == str

    str =  EEx.eval_string(
      "<%= if to_string(Mix.env) =~ ~r/\\Atest\\z/ do %><%= @bar %><%= end %>",
      [assigns: [bar: "baz"]],
      engine: EEx.X.PlainTextEngine
    )
    assert ~s("baz") == str

    str =  EEx.eval_string(
      "<%= @foo %><%= if false do %><%= @bar %><%= end %>",
      [assigns: [foo: "foo"]],
      engine: EEx.X.PlainTextEngine
    )
    assert ~s("foo") == str
    

    str =  EEx.eval_string(
      "<%= @foo %><%= if @boolean do %><%= @bar %><%= end %>",
      [assigns: [foo: "foo", boolean: true, bar: "bar" ]],
      engine: EEx.X.PlainTextEngine
    )
    assert ~s("foo""bar") == str
  end

end
