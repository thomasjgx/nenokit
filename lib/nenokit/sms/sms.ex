defmodule Nenokit.SMS do
  @moduledoc """
  Delivers SMS messages
  """

  def deliver(msisdn, message, _opts \\ []) do
    config = Application.fetch_env!(:nenokit, __MODULE__)

    Keyword.fetch!(config, :adapter)
    |> apply(:deliver, [msisdn, message, config])
  end
end
