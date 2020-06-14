defmodule NenokitWeb.Plugs.LoadNavigation do
  @moduledoc """
  This is a plug that load navigation menus
  """

  import Plug.Conn
  
  alias Nenokit.Pages

  def init(options) do
    options
  end

  def call(conn, _options) do
    main_menus = Pages.list_main_menus
    conn
    |> assign(:main_menus, main_menus)
  end
end