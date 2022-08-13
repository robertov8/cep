defmodule Cep.Error do
  @moduledoc false

  defstruct [:code, :message]

  def new(code, message) do
    %__MODULE__{
      code: code,
      message: message
    }
  end
end
