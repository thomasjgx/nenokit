defmodule Nenokit.Settings do
  @moduledoc """
  Settings context to handle all settings data manipulation 
  """

  alias Nenokit.Repo
  alias __MODULE__.Setting

  def create_settings(params) do
    %Setting{}
    |> Setting.changeset(params)
    |> Repo.insert
  end

  def change_settings(setting \\ %Setting{}) do
    Setting.changeset(setting, %{})
  end

  def update_settings(setting \\ %Setting{}, params) do
    setting
    |> Setting.changeset(params)
    |> Repo.update
  end

  def get_settings() do
    Repo.one(Setting)
  end
end
