defmodule SwaggerPoc.ProductTest do
  use SwaggerPoc.ModelCase

  alias SwaggerPoc.Product

  @valid_attrs %{quantity: 42, sku: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end
end
