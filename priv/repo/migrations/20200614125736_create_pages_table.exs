defmodule Nenokit.Repo.Migrations.CreatePagesTable do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :name, :string, null: false
      add :layout, :string
      add :content, :string

      timestamps()
    end

    create table(:blogs) do
      add :name, :string, null: false
      add :page_id, references(:pages, on_delete: :delete_all), null: false
      add :author_user_id, references(:users, on_delete: :delete_all), null: false
      add :content, :string

      timestamps()
    end

    create table(:main_menu) do
      add :name, :string, null: false
      add :page_id, references(:pages, on_delete: :delete_all)
      add :external_link, :string
      add :menu_index, :integer
  
      timestamps()
    end

    create table(:page_menus) do
      add :name, :string, null: false
      add :parent_page_id, references(:pages, on_delete: :delete_all)
      add :page_id, references(:pages, on_delete: :delete_all)
      add :external_link, :string
      add :menu_index, :integer

      timestamps()
    end
  end
end
