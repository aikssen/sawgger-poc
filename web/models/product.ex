defmodule SwaggerPoc.Product do
  use SwaggerPoc.Web, :model

  schema "products" do
    field :title, :string
    field :sku, :string
    field :quantity, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :sku, :quantity])
    |> validate_required([:title, :sku, :quantity])
  end
end
