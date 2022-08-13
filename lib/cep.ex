defmodule Cep do
  @moduledoc """
  Documentation for `Cep`.
  """

  alias Cep.{Error, Response}

  @callback get_by_number(number :: String.t()) :: %Response{} | %Error{}

  def get_by_number(number), do: adapter().get_by_number(number)

  defp adapter, do: Application.fetch_env!(:cep, :adapter)
end
