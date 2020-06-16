defmodule Nenokit.Accounts.UserNotifier do
  # For simplicity, this module simply logs messages to the terminal.
  # You should replace it by a proper e-mail or notification tool, such as:
  #
  #   * Swoosh - https://hexdocs.pm/swoosh
  #   * Bamboo - https://hexdocs.pm/bamboo
  #
  defp deliver(to, body) do
    NenokitWeb.Email.send_notification(to, "Notification", body)
    {:ok, %{to: to, body: body}}
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, """
    <br>
    ============================== <br>
    <br>
    Hi #{user.email},<br>
    <br>
    You can confirm your account by visiting the url below:<br>
    <br>
    #{url}<br>
    <br>
    If you didn't create an account with us, please ignore this.<br>
    <br>
    ==============================<br>
    """)
  end

  @doc """
  Deliver instructions to reset password account.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, """
    <br>
    ==============================<br>
    <br>
    Hi #{user.email},<br>
    <br>
    You can reset your password by visiting the url below:<br>
    <br>
    #{url}<br>
    <br>
    If you didn't request this change, please ignore this.<br>
    <br>
    ==============================<br>
    """)
  end

  @doc """
  Deliver instructions to update your e-mail.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, """
    <br>
    ==============================<br>
    <br>
    Hi #{user.email},<br>
    <br>
    You can change your e-mail by visiting the url below:<br>
    <br>
    #{url}<br>
    <br>
    If you didn't request this change, please ignore this.<br>
    <br>
    ==============================<br>
    """)
  end
end
