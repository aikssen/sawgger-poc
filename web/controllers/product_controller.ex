defmodule SwaggerPoc.ProductController do
  use SwaggerPoc.Web, :controller
  use PhoenixSwagger

  alias SwaggerPoc.Product

    def swagger_definitions do
    %{
      Product: swagger_schema do
        title "Product"
        description "A product in the store"
        properties do
          id :integer, "Product ID"
          title :string, "Product name", required: true
          sku :string, "Product sku", format: :integer, required: true
          quantity :string, "Product quantity", format: :integer
          inserted_at :string, "Creation timestamp", format: :datetime
          updated_at :string, "Update timestamp", format: :datetime
        end
        example %{
          id: 123,
          title: "Programming Elixir 1.3",
          sku: "BK-ELX-13-2016"
        }
      end,
      ProductRequest: swagger_schema do
        title "ProductRequest"
        description "POST body for creating a product"
        property :product, Schema.ref(:Product), "The product details"
      end,
      ProductResponse: swagger_schema do
        title "ProductResponse"
        description "Response schema for single product"
        property :data, Schema.ref(:Product), "The product details"
      end,
      ProductsResponse: swagger_schema do
        title "ProductsReponse"
        description "Response schema for multiple products"
        property :data, Schema.array(:Product), "The products details"
      end
    }
  end




  swagger_path(:index) do
    get "/api/products"
    summary "List Products"
    description "List all products in the database"
    produces "application/json"
    response 200, "OK", Schema.ref(:ProductsResponse), example: %{
      data: [
        %{id: 1, title: "Programming Elixir", sku: "BK-ELX-13-2016", quantity: 1, inserted_at: "2017-02-08T12:34:55Z", updated_at: "2017-02-12T13:45:23Z"},
        %{id: 2, title: "Programming Phoenix", sku: "BK-PHX-13-2016", quantity: 1, inserted_at: "2017-02-04T11:24:45Z", updated_at: "2017-02-15T23:15:43Z"}
      ]
    }
  end
  def index(conn, _params) do
    products = Repo.all(Product)
    render(conn, "index.json", products: products)
  end



  swagger_path(:create) do
    post "/api/products"
    summary "Create product"
    description "Creates a new product"
    consumes "application/json"
    produces "application/json"
    parameter :product, :body, Schema.ref(:ProductRequest), "The product details", example: %{
      product: %{title: "Programming Elixir", sku: "BK-ELX-13-2016", quantity: 1}
    }
    response 201, "Product created OK", Schema.ref(:ProductResponse), example: %{
      data: %{
        id: 1, title: "Programming Elixir", sku: "BK-ELX-13-2016", quantity: 1, inserted_at: "2017-02-08T12:34:55Z", updated_at: "2017-02-12T13:45:23Z"
      }
    }
  end
  def create(conn, %{"product" => product_params}) do
    changeset = Product.changeset(%Product{}, product_params)

    case Repo.insert(changeset) do
      {:ok, product} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", product_path(conn, :show, product))
        |> render("show.json", product: product)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(SwaggerPoc.ChangesetView, "error.json", changeset: changeset)
    end
  end



  swagger_path(:show) do
    get "/api/products/{id}"
    summary "Show Products"
    description "Show a product by ID"
    produces "application/json"
    parameter :id, :path, :integer, "Product ID", required: true, example: 1
    response 200, "OK", Schema.ref(:ProductResponse), example: %{
      data: %{
        id: 1, title: "Programming Elixir", sku: "BK-ELX-13-2016", quantity: 1, inserted_at: "2017-02-08T12:34:55Z", updated_at: "2017-02-12T13:45:23Z"
      }
    }
  end
  def show(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)
    render(conn, "show.json", product: product)
  end




  swagger_path(:update) do
    put "/api/products/{id}"
    summary "Update product"
    description "Update all attributes of a product"
    consumes "application/json"
    produces "application/json"
    parameters do
      id :path, :integer, "Product ID", required: true, example: 1
      user :body, Schema.ref(:ProductRequest), "The product details", example: %{
        product: %{title: "Programming Elixir", quantity: 1}
      }
    end
    response 200, "Updated Successfully", Schema.ref(:ProductResponse), example: %{
      data: %{
        id: 1, title: "Programming Elixir", sku: "BK-ELX-13-2016", quantity: 1, inserted_at: "2017-02-08T12:34:55Z", updated_at: "2017-02-12T13:45:23Z"
      }
    }
  end
  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Repo.get!(Product, id)
    changeset = Product.changeset(product, product_params)

    case Repo.update(changeset) do
      {:ok, product} ->
        render(conn, "show.json", product: product)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(SwaggerPoc.ChangesetView, "error.json", changeset: changeset)
    end
  end



  swagger_path(:delete) do
    delete "/api/products/{id}"
    summary "Delete Product"
    description "Delete a product by ID"
    parameter :id, :path, :integer, "Product ID", required: true, example: 1
    response 203, "No Content - Deleted Successfully"
  end
  def delete(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(product)

    send_resp(conn, :no_content, "")
  end
end
