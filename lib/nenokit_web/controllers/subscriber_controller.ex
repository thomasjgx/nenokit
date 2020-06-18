defmodule NenokitWeb.SubscriberController do
  use NenokitWeb, :controller

  alias Nenokit.{Surveys, Surveys.SurveySubscribers, Accounts, AuditTrails}

  def index(conn, _params) do
    subscribers = SurveySubscribers.list_survey_subscribers
    render(conn, "index.html", subscribers: subscribers)
  end

  def new(conn, _params) do
    changeset = SurveySubscribers.change_survey_subscriber
    surveys = Surveys.list_surveys |> Enum.map(fn survey -> {survey.name, survey.id} end)
    render(conn, "new.html", changeset: changeset, subscriber: nil, surveys: surveys)
  end

  def create(conn, %{"survey_subscriber" => params}) do
    # Get or create the user first
    user_params = %{
      "name" => params["name"],
      "email" => params["email"],
      "phone" => params["phone"],
      "password" => "#{params["phone"]}#{params["email"]}"
    }
    user_id = 
      if user = Accounts.get_user_by_email_or_phone(params["email"], params["phone"]) do
        user.id
      else
        case Accounts.register_user(user_params) do
          {:ok, user} ->
            user.id
          {:error, changeset} = error ->
            IO.inspect changeset
            error
        end
      end

    case user_id do
      {:error, _changeset} ->
        surveys = Surveys.list_surveys |> Enum.map(fn survey -> {survey.name, survey.id} end)
        changeset = SurveySubscribers.change_survey_subscriber(params)
        render(conn, "new.html", changeset: changeset, subscriber: nil, surveys: surveys)
      user_id ->
        # Create subscriber
        subscriber_params = %{
          "user_id" => user_id,
          "survey_id" => params["survey_id"]
        }
        case SurveySubscribers.create_survey_subscriber(subscriber_params) do
          {:ok, survey_subscriber} ->
            # Log action in audit trial
            current_user = conn.assigns.current_user
            AuditTrails.create_audit_trail(current_user, %{"action" => "Created a new survey subscriber", "module" => "admin_survey_subscriber", "record_id" => survey_subscriber.id})

            conn
            |> put_flash(:success, "Survey subscriber created successfully")
            |> redirect(to: Routes.subscriber_path(conn, :index))
          {:error, changeset} ->
            surveys = Surveys.list_surveys |> Enum.map(fn survey -> {survey.name, survey.id} end)
            render(conn, "new.html", changeset: changeset, subscriber: nil, surveys: surveys)
        end
    end
  end

  def show(conn, %{"id" => subscriber_id}) do
    subscriber = SurveySubscribers.get_survey_subscriber(subscriber_id)
    render(conn, "show.html", subscriber: subscriber)
  end

  def delete(conn, %{"id" => subscriber_id}) do
    subscriber = SurveySubscribers.get_survey_subscriber(subscriber_id)
    {:ok, _subscriber} = SurveySubscribers.delete_survey_subscriber(subscriber)

    # Log action in audit trial
    current_user = conn.assigns.current_user
    AuditTrails.create_audit_trail(current_user, %{"action" => "Deleted a subscriber", "module" => "admin_survey_subscriber", "record_id" => subscriber.id})

    conn
    |> put_flash(:info, "Subscriber deleted successfully.")
    |> redirect(to: Routes.subscriber_path(conn, :index))
  end
end
