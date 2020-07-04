defmodule NenokitWeb.WorkflowView do
  use NenokitWeb, :view

  alias Elixlsx.{Workbook, Sheet}

  def get_days_ago(date) do
    case date |> Timex.format("{relative}", :relative) do
      {:ok, relative_time} ->
        relative_time
      _ ->
        date
    end
  end

  def render("export.xlsx", %{survey: survey, submissions: submissions}) do
    report_generator(survey, submissions)
    |> Elixlsx.write_to_memory("export.xlsx")
    |> elem(1)
    |> elem(1)
  end

  def report_generator(survey, submissions) do
    fields = Poison.decode!(survey.schema.form_data) |> Enum.map(fn field ->
      Map.get(field, "label")
    end)

    header  = [
      "Time",
      "Submitted by",
      "Phone",
      "Status"
    ] ++ fields

    rows = submissions |> Enum.map(&(row(survey, &1)))
    %Workbook{sheets: [%Sheet{name: "Submissions", rows: [header] ++ rows}]}
  end

  def row(survey, submission) do
    fields = Poison.decode!(survey.schema.form_data) |> Enum.map(fn field ->
      submission.schema["form_data"][field["name"]]
    end)

    [
      get_days_ago(submission.inserted_at),
      submission.user.name,
      submission.user.phone,
      submission.workflow_stage.name
    ] ++ fields
  end
end
