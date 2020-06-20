defmodule Nenokit.SMS.Adapter do
  @callback deliver(String.t(), String.t(), Keyword.t()) :: {:ok, any()} | {:error, any()}
end
