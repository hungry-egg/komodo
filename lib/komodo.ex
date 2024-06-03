defmodule Komodo do
  @readme_content File.read!("README.md")

  @moduledoc """
  #{@readme_content}
  """
end
