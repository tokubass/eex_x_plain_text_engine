defmodule EEx.X.PlainTextEngine do
  @moduledoc """
  Documentation for EEx.X.PlainTextEngine.
  """

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__), only: [to_plain: 1]
    end
  end

  use EEx.Engine

  defstruct mark: true, value: nil

  @doc """

  ## Examples
    iex> EEx.eval_string(
    ...> "<%= atom %>",
    ...> [ atom: to_plain(:api) ],
    ...> engine: EEx.X.PlainTextEngine
    ...> )
    ":api"

  """

  def to_plain(x) do
    %__MODULE__{value: x}
  end
  
  def is_my_struct?(x) do
    is_map(x) && Map.has_key?(x, :__struct__) && x.__struct__ == EEx.X.PlainTextEngine
  end

  def handle_expr(buf, "=", expr) do
    quote do
      require unquote(__MODULE__)
    
      u_buf = unquote(buf)
      u_expr   = unquote(expr)

      expr_string =  if unquote(__MODULE__).is_my_struct?(unquote(expr)) do
         val =  u_expr.value
         case val do
           _ when is_list(val) 
             ->
             if Enum.all?(val, fn(x) -> is_integer(x) end) do
               unquote(__MODULE__).normalize_for_print(unquote(expr).value)
               |> inspect
               |> String.replace_prefix(~s("), "")
               |> String.replace_suffix(~s("), "")
             else
               inspect(val)   
             end
           _
             -> inspect(val)
         end
      else
        String.Chars.to_string(u_expr)
      end

       u_buf <> expr_string
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
