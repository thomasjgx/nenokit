defmodule NenokitWeb.SMS do
    alias Nenokit.Settings
    
    def send_survey_notification(subscriber) do
      settings = Settings.get_settings

      url = NenokitWeb.TinyUrl.shorten("http://localhost:4000/survey/#{subscriber.survey.id}")
      Nenokit.SMS.deliver(subscriber.user.phone, "#{settings.configuration.site_name}: Please fill submit the following survey: #{url}")
    end
  end
  