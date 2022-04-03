defmodule BeerCatalogWeb.BeerController do
  use BeerCatalogWeb, :controller

  alias BeerCatalog.Catalog
  alias BeerCatalog.Catalog.Beer

  def index(conn, _params) do
    beers = Catalog.list_beers()
    render(conn, "index.html", beers: beers)
  end

  def new(conn, _params) do
    changeset = Catalog.change_beer(%Beer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"beer" => beer_params}) do
    case Catalog.create_beer(beer_params) do
      {:ok, beer} ->
        conn
        |> put_flash(:info, "Beer created successfully.")
        |> redirect(to: Routes.beer_path(conn, :show, beer))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    beer = Catalog.get_beer!(id)
    render(conn, "show.html", beer: beer)
  end

  def edit(conn, %{"id" => id}) do
    beer = Catalog.get_beer!(id)
    changeset = Catalog.change_beer(beer)
    render(conn, "edit.html", beer: beer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "beer" => beer_params}) do
    beer = Catalog.get_beer!(id)

    case Catalog.update_beer(beer, beer_params) do
      {:ok, beer} ->
        conn
        |> put_flash(:info, "Beer updated successfully.")
        |> redirect(to: Routes.beer_path(conn, :show, beer))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", beer: beer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    beer = Catalog.get_beer!(id)
    {:ok, _beer} = Catalog.delete_beer(beer)

    conn
    |> put_flash(:info, "Beer deleted successfully.")
    |> redirect(to: Routes.beer_path(conn, :index))
  end
end
