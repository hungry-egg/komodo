defmodule Komodo.Helpers do
  @valid_variable_char "[\\w_$]"

  @doc """
  Converts a string path spec to an array for use in the komodo javascript library

  Example:
  iex> Komodo.Helpers.arguments_path("&1.inner[2].name")
  "0.inner.2.name"

  """
  def arguments_path(path_string) when is_binary(path_string) do
    [first_part | rest] =
      path_string
      |> String.replace(~r/\[(#{@valid_variable_char}+)\]/, ".\\1")
      |> String.split(".")

    unless first_part =~ ~r/^&\d+$/ do
      raise "The first part of the path needs to have the form '&n' for integer n, e.g. '&2'"
    end

    "&" <> path_0 = first_part
    path_0 = ((path_0 |> String.to_integer()) - 1) |> Integer.to_string()
    path = [path_0 | rest]

    unless Enum.all?(path, fn part -> part =~ ~r/^#{@valid_variable_char}+$/ end) do
      raise "Unable to parse path '#{path_string}' - every part must have characters that match the regex #{@valid_variable_char}"
    end

    Enum.join(path, ".")
  end

  def normalise_callback_spec(event_name) when is_binary(event_name) do
    [event_name]
  end

  def normalise_callback_spec({event_name, path_string})
      when is_binary(event_name) and is_binary(path_string) do
    [event_name, arguments_path(path_string)]
  end

  def normalise_callback_spec({event_name, path_strings})
      when is_binary(event_name) and is_list(path_strings) do
    [event_name, Enum.map(path_strings, &arguments_path/1)]
  end

  def normalise_callback_spec({event_name, path_string_lookup = %{}})
      when is_binary(event_name) do
    [
      event_name,
      path_string_lookup
      |> Enum.map(fn {k, v} -> {k, arguments_path(v)} end)
      |> Enum.into(%{})
    ]
  end
end
