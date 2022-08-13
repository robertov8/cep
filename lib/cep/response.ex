defmodule Cep.Response do
  @moduledoc false

  defstruct [
    :cep,
    :logradouro,
    :complemento,
    :bairro,
    :localidade,
    :uf,
    :ibge,
    :gia,
    :ddd,
    :siafi
  ]

  def new(attrs) do
    %__MODULE__{
      cep: Map.get(attrs, "cep"),
      logradouro: Map.get(attrs, "logradouro"),
      complemento: Map.get(attrs, "complemento"),
      bairro: Map.get(attrs, "bairro"),
      localidade: Map.get(attrs, "localidade"),
      uf: Map.get(attrs, "uf"),
      ibge: Map.get(attrs, "ibge"),
      gia: Map.get(attrs, "gia"),
      ddd: Map.get(attrs, "ddd"),
      siafi: Map.get(attrs, "siafi")
    }
  end
end
