defmodule EEx.X.PlainTextEngine do
  @moduledoc """
  Documentation for EEx.X.PlainTextEngine.
  """

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__), only: [as_original: 1]
    end
  end

  use EEx.Engine

  defstruct value: nil

  @doc """

  ## Examples
    iex> EEx.eval_string("<%= atom %>", [ atom: :api ])
    "api"

    iex> EEx.eval_string("<%= atom %>", [ atom: :api ], engine: EEx.X.PlainTextEngine)
    ":api"

  """

  def as_original(x) do
    %__MODULE__{value: x}
  end
  
  def is_my_struct?(x) do
    is_map(x) && Map.has_key?(x, :__struct__) && x.__struct__ == EEx.X.PlainTextEngine
  end


  def handle_expr(buf, "=", {:if, _, _} = expr) do
    super(buf,"=", expr)
  end

  def handle_expr(buf, "=", expr) do
    quote do
      require unquote(__MODULE__)
    
      expr_string =  if unquote(__MODULE__).is_my_struct?(unquote(expr)) do
        String.Chars.to_string(unquote(expr).value)
      else
        cond do

          is_list(unquote(expr)) 
            ->
            if Enum.all?(unquote(expr), fn(x) -> is_integer(x) end) do
              unquote(__MODULE__).normalize_for_print(unquote(expr))
              |> inspect
              |> String.replace_prefix(~s("), "")
              |> String.replace_suffix(~s("), "")
            else
              inspect(unquote(expr))   
            end
          is_binary(unquote(expr))
            -> ~s(") <> unquote(expr) <> ~s(")
          true
            -> inspect(unquote(expr))
        end
      end

      unquote(buf) <> expr_string

    end
  end

 def handle_expr(buf, mark, expr) do
   super(buf, mark, expr)
  end

  defmacro normalize_for_print(list) do
    quote do
      ([0] ++ unquote(list)) |> inspect |> String.replace_prefix("[0, ", "[")
    end
  end
  
end
