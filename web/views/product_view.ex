defmodule SwaggerPoc.ProductView do
  use SwaggerPoc.Web, :view

  def render("index.json", %{products: products}) do
    %{data: render_many(products, SwaggerPoc.ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, SwaggerPoc.ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      title: product.title,
      sku: product.sku,
      quantity: product.quantity}
  end
end
