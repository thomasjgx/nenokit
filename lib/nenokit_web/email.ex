defmodule NenokitWeb.Email do
  use Bamboo.Phoenix, view: NenokitWeb.EmailView

  alias Nenokit.Settings
  alias NenokitWeb.Mailer

  def welcome_message(email_address) do
    settings = Settings.get_settings

    if !is_nil(settings) and settings.configuration.welcome_message_enabled == "yes" do
      base_email(settings)
      |> to(email_address)
      |> subject(settings.configuration.welcome_message_subject)
      |> render(:welcome, content: settings.configuration.welcome_message_content)
      |> Mailer.deliver_later
    end
  end

  def send_notification(email_address, subject, body) do
    settings = Settings.get_settings

    if !is_nil(settings) do
      base_email(settings)
      |> to(email_address)
      |> subject("#{settings.configuration.site_name}: #{subject}")
      |> render(:welcome, content: body)
      |> Mailer.deliver_later
    end
  end

  defp base_email(settings) do
    new_email()
    |> from(settings.configuration.site_email)
    |> put_html_layout({NenokitWeb.LayoutView, "email.html"})
  end
end
