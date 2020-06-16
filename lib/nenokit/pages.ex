defmodule Nenokit.Pages do
  @moduledoc """
  Pages context to handle all pages data manipulation
  """
  import Ecto.Query, only: [from: 2]

  alias Nenokit.Repo
  alias __MODULE__.{Page, MainMenu, PageMenu}

  def list_pages() do
    Repo.all(from p in Page, select: p, order_by: [asc: :id])
  end

  def search_pages(search) do
    Repo.all(from p in Page, select: p, where: ilike(p.name, ^"%#{search}%"), order_by: [asc: :id])
  end

  def change_page(page \\ %Page{}) do
    Page.changeset(page, %{})
  end

  def create_page(params) do
    %Page{}
    |> Page.changeset(params)
    |> Repo.insert
  end

  def update_page(page, params) do
    page
    |> Page.changeset(params)
    |> Repo.update
  end

  def get_first() do
    Repo.one(from p in Page, order_by: [asc: :id], limit: 1)
  end

  def get_page(id) do
    Repo.get(Page, id)
  end

  def delete_page(page) do
    Repo.delete(page)
  end

  def get_page_count() do
    Repo.one(from p in Page, select: count(p.id))
  end

  def list_main_menus() do
    Repo.all(from m in MainMenu, select: m, order_by: [asc: :menu_index])
  end

  def change_main_menu(main_menu \\ %MainMenu{}) do
    MainMenu.changeset(main_menu, %{})
  end

  def create_main_menu(params) do
    %MainMenu{}
    |> MainMenu.changeset(params)
    |> Repo.insert
  end

  def update_main_menu(main_menu, params) do
    main_menu
    |> MainMenu.changeset(params)
    |> Repo.update
  end

  def get_main_menu(id) do
    Repo.get(MainMenu, id)
  end

  def delete_main_menu(main_menu) do
    Repo.delete(main_menu)
  end

  def list_page_menus(page) do
    Repo.all(from m in PageMenu, select: m, where: m.parent_page_id == ^page.id, order_by: [asc: :id])
  end

  def change_page_menu(page_menu \\ %PageMenu{}) do
    PageMenu.changeset(page_menu, %{})
  end

  def create_page_menu(page, params) do
    params_with_parent_page = params |> Map.put("parent_page_id", page.id)
    %PageMenu{}
    |> PageMenu.changeset(params_with_parent_page)
    |> Repo.insert
  end

  def update_page_menu(page_menu, params) do
    page_menu
    |> PageMenu.changeset(params)
    |> Repo.update
  end

  def get_page_menu(id) do
    Repo.get(PageMenu, id)
  end

  def delete_page_menu(page_menu) do
    Repo.delete(page_menu)
  end
end
