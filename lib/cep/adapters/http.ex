defmodule Cep.Adapters.Http do
  @moduledoc false

  @behaviour Cep

  use Tesla

  alias Cep.{Error, Response}

  plug(Tesla.Middleware.BaseUrl, "https://viacep.com.br/ws/")
  plug(Tesla.Middleware.JSON)

  @impl Cep
  def get_by_number(number) do
    "#{number}/json"
    |> get()
    |> handle_response()
  end

  defp handle_response({:ok, %Tesla.Env{status: 400}}) do
    Error.new(400, "Bad Request")
  end

  defp handle_response({:ok, %Tesla.Env{body: %{"erro" => "true"}}}) do
    Error.new(422, "Unprocessable Entity")
  end

  defp handle_response({:ok, %Tesla.Env{body: body}}) do
    Response.new(body)
  end

  defp handle_response(_) do
    Error.new(500, "Internal Server Error")
  end
end
