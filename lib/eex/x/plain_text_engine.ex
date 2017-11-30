defmodule EEx.X.PlainTextEngine do
  @moduledoc """
  Documentation for EEx.X.PlainTextEngine.
  """
  use EEx.Engine

  @doc """

  ## Examples
    iex> EEx.eval_string(
    ...> "<%= role %>, <%= port %>, <%= text %>",
    ...> [ role: :api, port: 9000, text: "sample" ],
    ...> engine: EEx.X.PlainTextEngine
    ...> )
    ":api, 9000, \"sample\""

  """
  def handle_expr(buffer, "=", expr) do
    quote do
      require unquote(__MODULE__)
      if unquote(__MODULE__).is_charlist?(unquote(expr)) do
        raise "not allow charlist in config file"
      end

      unquote(buffer) <> inspect(unquote(expr))
    end
  end

  def handle_expr(buffer, mark, expr) do
    super(buffer, mark, expr)
  end

  defmacro is_charlist?(x) do
    quote do
      is_list(unquote(x)) && inspect(unquote(x)) =~ ~r/\'/
    end
  end

end
