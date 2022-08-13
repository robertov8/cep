defmodule CepTest do
  use ExUnit.Case

  alias Cep.{Error, Response}

  setup do
    Hammox.stub(CepMock, :get_by_number, &Cep.Adapters.Mock.get_by_number/1)

    :ok
  end

  describe "get_by_number/1" do
    test "when the number is invalid, returns an error" do
      response = Cep.get_by_number("123")
      expected_response = %Error{code: 400, message: "Bad Request"}

      assert response == expected_response
    end

    test "when the number is non-existent, returns an error" do
      response = Cep.get_by_number("99999999")
      expected_response = %Error{code: 422, message: "Unprocessable Entity"}

      assert response == expected_response
    end

    test "when the number is valid, returns the result" do
      response = Cep.get_by_number("28080020")
      expected_response = %Response{cep: "28080020"}

      assert response == expected_response
    end

    test "when something unexpected happens, returns an error" do
      response = Cep.get_by_number("28080010")
      expected_response = %Error{code: 500, message: "Internal Server Error"}

      assert response == expected_response
    end
  end
end
