defmodule SwaggerPoc.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :title, :string
      add :sku, :string
      add :quantity, :integer

      timestamps()
    end

  end
end
