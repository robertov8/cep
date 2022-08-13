defmodule Cep.Adapters.Mock do
  @moduledoc false

  @behaviour Cep

  alias Cep.{Error, Response}

  @impl Cep
  def get_by_number("123"), do: Error.new(400, "Bad Request")
  def get_by_number("99999999"), do: Error.new(422, "Unprocessable Entity")
  def get_by_number("28080010"), do: Error.new(500, "Internal Server Error")
  def get_by_number(number), do: Response.new(%{"cep" => "#{number}"})
end
