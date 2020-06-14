defmodule NenokitWeb.AdminPageView do
  use NenokitWeb, :view

  def get_days_ago(date) do
    case date |> Timex.format("{relative}", :relative) do
      {:ok, relative_time} ->
        relative_time
      _ ->
        date
    end
  end
end