defmodule Nenokit.Surveys.SurveySubscribers.SendSubscriberSurveys do
  use GenServer

  @interval 10_000

  alias Nenokit.{Surveys, Surveys.SurveySubscribers}

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.send_after(self(), :work, @interval)
    {:ok, %{last_run_at: nil}}
  end

  def handle_info(:work, _state) do
    fetch_and_send_surveys()
    Process.send_after(self(), :work, @interval)
    {:noreply, %{last_run_at: :calendar.local_time()}}
  end

  def fetch_and_send_surveys() do
    IO.inspect "Running fetch and send surveys..."
    # Get all the surveys that have subscription enableds
    surveys = Surveys.list_surveys_with_subscription_enabled
    surveys |> Enum.each(fn survey ->
      # Get any subscriptions that are not sent and their days have elapsed
      subscribers = SurveySubscribers.fetch_survey_subscribers_to_notify(survey)
      IO.inspect "#{length(subscribers)} subscribers need to be notified"

      # Send notification
      subscribers |> Enum.each(fn subscriber ->
        case survey.schema.survey_subscription_medium do
          "email" ->
            NenokitWeb.Email.send_survey_notification(subscriber)
          "sms" ->
            NenokitWeb.SMS.send_survey_notification(subscriber)
        end

        # Update subscriber to sent
        SurveySubscribers.update_survey_subscriber(subscriber, %{"sent" => true})
      end)
    end)
  end
end
