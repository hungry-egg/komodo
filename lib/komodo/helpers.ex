defmodule Komodo.Helpers do
  alias Komodo.Macros
  require Macros

  @valid_variable_char "[\\w_$]"

  @doc """
  Converts a string path spec to an array for use in the komodo javascript library

  Example:
  iex> Komodo.Helpers.arguments_path("event.inner[2].name", 0)
  "0.inner.2.name"

  """
  def arguments_path(code_str, arg_num_of_root)
      when is_binary(code_str) and is_integer(arg_num_of_root) do
    case parse_path(code_str) do
      {:ok, [_root | rest]} ->
        [Integer.to_string(arg_num_of_root) | rest] |> Enum.join(".")

      {:error, error} ->
        raise error
    end
  end

  defp parse_path(code_str) when is_binary(code_str) do
    path =
      code_str
      |> String.replace(~r/\[(#{@valid_variable_char}+)\]/, ".\\1")
      |> String.split(".")

    if Enum.all?(path, fn part -> part =~ ~r/^#{@valid_variable_char}+$/ end) do
      {:ok, path}
    else
      {:error,
       "Unable to parse path '#{code_str}' - every part must have characters that match the regex #{@valid_variable_char}"}
    end
  end

  @doc """
  Example:
  iex> Komodo.Helpers.maybe_replace_code_with_path_string("markers[3].x", ["markers"])
  "0.3.x"
  """
  def maybe_replace_code_with_path_string(code_str, arg_names)
      when is_binary(code_str) and is_list(arg_names) do
    case parse_path(code_str) do
      {:ok, [root | _rest]} ->
        arg_index = arg_names |> Enum.find_index(fn arg_name -> root == to_string(arg_name) end)

        if arg_index do
          arguments_path(code_str, arg_index)
        end

      {:error, _} ->
        nil
    end
  end

  def normalise_callback_spec(event_name) when is_binary(event_name) do
    [event_name]
  end

  def normalise_callback_spec({event_name, callback_spec}) when is_binary(event_name) do
    [event_name, Macros.normalise_param_spec(callback_spec)]
  end

  # def normalise_callback_spec({event_name, path_strings})
  #     when is_binary(event_name) and is_list(path_strings) do
  #   [event_name, Enum.map(path_strings, &arguments_path/1)]
  # end

  # def normalise_callback_spec({event_name, path_string_lookup = %{}})
  #     when is_binary(event_name) do
  #   [
  #     event_name,
  #     path_string_lookup
  #     |> Enum.map(fn {k, v} -> {k, arguments_path(v)} end)
  #     |> Enum.into(%{})
  #   ]
  # end
end
