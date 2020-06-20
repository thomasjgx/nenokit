defmodule Nenokit.SMS.LogAdapter do
  @moduledoc """
  Writes sms message to log
  """

  require Logger

  @behaviour Nenokit.SMS.Adapter

  @impl true
  def deliver(msisdn, message, config) do
    Logger.info(
      "Delivering SMS: msisdn: #{msisdn}, message: #{message}, config: #{inspect(config)}"
    )

    send(self(), {:sms, message, config})
    {:ok, nil}
  end
end
