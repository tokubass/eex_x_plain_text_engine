defmodule EEx.X.PlainTextEngineTest do
  use ExUnit.Case

  test "basic" do
    str =  EEx.eval_string("""
config :app, :role, <%= role %>
config :app, :zzz,
  port: <%= port %>,
  text: <%= text %>
""", [ role: :api, port: 9000, text: "sample" ], engine: EEx.X.PlainTextEngine)

    assert """
config :app, :role, :api
config :app, :zzz,
  port: 9000,
  text: "sample"
""" == str

  end
end
