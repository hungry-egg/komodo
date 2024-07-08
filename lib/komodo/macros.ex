defmodule Komodo.Macros do
  alias Komodo.Helpers

  defmacro normalise_param_spec(ast) do
    case(ast) do
      # fn arg -> ... end
      {:fn, _,
       [
         {:->, _,
          [
            [{arg1, _, _}],
            return_val_ast
          ]}
       ]} ->
        parse_fn_return_val(return_val_ast, [arg1])

      _ ->
        [ast, nil]
    end
  end

  defp parse_fn_return_val(return_val_ast, arg_names) when is_list(arg_names) do
    case return_val_ast do
      {:%{}, _, map_ast} ->
        {static_kv_pairs, dynamic_kv_pairs} = split_by_dynamic_parts(map_ast, arg_names)
        [{:%{}, [], static_kv_pairs}, {:%{}, [], dynamic_kv_pairs}]

      ast ->
        code_str = Macro.to_string(ast)

        if path_string = Helpers.maybe_replace_code_with_path_string(code_str, arg_names) do
          [nil, path_string]
        else
          [ast, nil]
        end
    end
  end

  defp split_by_dynamic_parts(kv_pairs, arg_names) do
    Enum.reduce(kv_pairs, {[], []}, fn {k, val_ast}, {static_kv_pairs, dynamic_kv_pairs} ->
      code_str = Macro.to_string(val_ast)

      path_string = Helpers.maybe_replace_code_with_path_string(code_str, arg_names)

      if path_string do
        {static_kv_pairs, [{k, path_string} | dynamic_kv_pairs]}
      else
        {[{k, val_ast} | static_kv_pairs], dynamic_kv_pairs}
      end
    end)
  end
end
