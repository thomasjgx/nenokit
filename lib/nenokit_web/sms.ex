defmodule NenokitWeb.SMS do
    alias Nenokit.Settings
    
    def send_survey_notification(subscriber) do
      settings = Settings.get_settings

      url = NenokitWeb.TinyUrl.shorten("#{NenokitWeb.Endpoint.url()}/survey/#{subscriber.survey.id}")
      Nenokit.SMS.deliver(subscriber.user.phone, "#{settings.configuration.site_name}: Please fill submit the following survey: #{url}")
    end

    def send_survey_subscription_welcome(subscriber) do
      settings = Settings.get_settings

      Nenokit.SMS.deliver(subscriber.user.phone, "#{settings.configuration.site_name}: You have successfully been signed up for the following survey: #{subscriber.survey.name}")
    end
  end
  
