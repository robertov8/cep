defmodule Cep.Adapters.HttpTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias Cep.{Adapters.Http, Error, Response}

  setup do
    mock(fn
      %{method: :get, url: "https://viacep.com.br/ws/123/json"} ->
        setup_http_invalid_request()

      %{method: :get, url: "https://viacep.com.br/ws/99999999/json"} ->
        setup_http_unprocessable_entity()

      %{method: :get, url: "https://viacep.com.br/ws/28080020/json"} ->
        setup_http_success()

      %{method: :get} ->
        setup_http_internal_server_error()
    end)
  end

  describe "get_by_number/1" do
    test "when the number is invalid, returns an error" do
      response = Http.get_by_number("123")
      expected_response = %Error{code: 400, message: "Bad Request"}

      assert response == expected_response
    end

    test "when the number is non-existent, returns an error" do
      response = Http.get_by_number("99999999")
      expected_response = %Error{code: 422, message: "Unprocessable Entity"}

      assert response == expected_response
    end

    test "when the number is valid, returns the result" do
      response = Http.get_by_number("28080020")

      expected_response = %Response{
        bairro: "Parque Prazeres",
        cep: "28080-020",
        complemento: "",
        ddd: "22",
        gia: "",
        ibge: "3301009",
        localidade: "Campos dos Goytacazes",
        logradouro: "Rua Djalma Lima",
        siafi: "5819",
        uf: "RJ"
      }

      assert response == expected_response
    end

    test "when something unexpected happens, returns an error" do
      response = Http.get_by_number("28080010")
      expected_response = %Error{code: 500, message: "Internal Server Error"}

      assert response == expected_response
    end
  end

  defp setup_http_invalid_request do
    {:ok,
     %Tesla.Env{
       body: "",
       method: :get,
       opts: [],
       query: [],
       status: 400,
       url: "https://viacep.com.br/ws/123/json"
     }}
  end

  defp setup_http_unprocessable_entity do
    {:ok,
     %Tesla.Env{
       headers: [{"content-type", "application/json; charset=utf-8"}],
       body: %{"erro" => "true"},
       method: :get,
       opts: [],
       query: [],
       status: 200,
       url: "https://viacep.com.br/ws/99999999/json"
     }}
  end

  defp setup_http_success do
    {:ok,
     %Tesla.Env{
       headers: [{"content-type", "application/json; charset=utf-8"}],
       body: %{
         "bairro" => "Parque Prazeres",
         "cep" => "28080-020",
         "complemento" => "",
         "ddd" => "22",
         "gia" => "",
         "ibge" => "3301009",
         "localidade" => "Campos dos Goytacazes",
         "logradouro" => "Rua Djalma Lima",
         "siafi" => "5819",
         "uf" => "RJ"
       },
       method: :get,
       opts: [],
       query: [],
       status: 200,
       url: "https://viacep.com.br/ws/28080020/json"
     }}
  end

  defp setup_http_internal_server_error do
    {:error,
     %Tesla.Env{
       headers: [{"content-type", "application/json; charset=utf-8"}],
       body: nil,
       method: :get,
       opts: [],
       query: [],
       status: 500,
       url: "https://viacep.com.br/ws/28080020/json"
     }}
  end
end
