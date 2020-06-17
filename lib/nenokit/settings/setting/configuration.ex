defmodule Nenokit.Settings.Configuration do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :site_name
    field :site_description
    field :site_keywords
    field :site_email
    field :announcement_enabled
    field :announcement_text
    field :welcome_message_enabled
    field :welcome_message_subject
    field :welcome_message_content
    field :terms_and_conditions
    field :privacy_policy
    field :sso_enabled
    field :sso_login_url
    field :sso_registration_url
  end

  @doc false
  def changeset(%__MODULE__{} = configuration, attrs) do
    configuration
    |> cast(attrs, [
      :site_name,
      :site_description,
      :site_keywords,
      :site_email,
      :announcement_enabled,
      :announcement_text,
      :welcome_message_enabled,
      :welcome_message_subject,
      :welcome_message_content,
      :terms_and_conditions,
      :privacy_policy,
      :sso_enabled,
      :sso_login_url,
      :sso_registration_url
    ])
  end
end
