defmodule Nenokit.SMS.PesaflowAdapter do
  @moduledoc """
  Pesaflow SMS Adapter

  ## Config
      * pesaflow_source: Message source i.e. short code or mask
      * pesaflow_endpoint: URL to pesaflow SMS service
  """
  require Logger

  @behaviour Nenokit.SMS.Adapter

  @impl true
  def deliver(msisdn, message, config) do
    payload =
      Enum.map(%{"MSISDN" => msisdn, "MESSAGE" => message, "SOURCE" => source(config)}, & &1)

    http_client =
      Application.get_env(:nenokit, Nenokit.HTTPClient)
      |> Keyword.fetch!(:adapter)

    case http_client.request(:post, endpoint(config), {:form, payload}, [], []) do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %{status_code: status_code} = response} ->
        require Logger

        Logger.warn(
          "Pesaflow SMS Error with status code #{status_code}, MSISDN: #{msisdn} and MESSAGE: #{
            message
          } with body: #{inspect(response)}"
        )

        {:error, status_code: status_code}

      {:error, %{reason: reason} = e} ->
        Logger.error("Pesaflow HTTP Error: #{inspect(e)}")
        {:error, reason: reason}
    end
  end

  defp endpoint(config) do
    Keyword.fetch!(config, :pesaflow_endpoint)
  end

  defp source(config) do
    Keyword.fetch!(config, :pesaflow_source)
  end
end
