defmodule Nenokit.HTTPClient do
  @moduledoc """
  HTTPClient interface

  Serves as the central interface for http client requests so that
  different adpaters can be configured for different environments.
  """

  @callback request(
              atom(),
              String.t(),
              String.t() | {:form, Keyword.t()},
              Keyword.t(),
              Keyword.t()
            ) :: {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}

  @doc false
  def adapter() do
    Application.fetch_env!(:nenokit, __MODULE__)
    |> Keyword.fetch!(:adapter)
  end

  def options() do
    Application.fetch_env!(:nenokit, __MODULE__)
    |> Keyword.get(:adapter_options, [])
  end
end
