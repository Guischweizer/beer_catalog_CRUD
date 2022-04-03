defmodule BeerCatalogWeb.BeerControllerTest do
  use BeerCatalogWeb.ConnCase

  import BeerCatalog.CatalogFixtures

  @create_attrs %{brand: "some brand", origin: "some origin", quantity: 42, style: "some style"}
  @update_attrs %{brand: "some updated brand", origin: "some updated origin", quantity: 43, style: "some updated style"}
  @invalid_attrs %{brand: nil, origin: nil, quantity: nil, style: nil}

  describe "index" do
    test "lists all beers", %{conn: conn} do
      conn = get(conn, Routes.beer_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Beers"
    end
  end

  describe "new beer" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.beer_path(conn, :new))
      assert html_response(conn, 200) =~ "New Beer"
    end
  end

  describe "create beer" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.beer_path(conn, :create), beer: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.beer_path(conn, :show, id)

      conn = get(conn, Routes.beer_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Beer"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.beer_path(conn, :create), beer: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Beer"
    end
  end

  describe "edit beer" do
    setup [:create_beer]

    test "renders form for editing chosen beer", %{conn: conn, beer: beer} do
      conn = get(conn, Routes.beer_path(conn, :edit, beer))
      assert html_response(conn, 200) =~ "Edit Beer"
    end
  end

  describe "update beer" do
    setup [:create_beer]

    test "redirects when data is valid", %{conn: conn, beer: beer} do
      conn = put(conn, Routes.beer_path(conn, :update, beer), beer: @update_attrs)
      assert redirected_to(conn) == Routes.beer_path(conn, :show, beer)

      conn = get(conn, Routes.beer_path(conn, :show, beer))
      assert html_response(conn, 200) =~ "some updated brand"
    end

    test "renders errors when data is invalid", %{conn: conn, beer: beer} do
      conn = put(conn, Routes.beer_path(conn, :update, beer), beer: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Beer"
    end
  end

  describe "delete beer" do
    setup [:create_beer]

    test "deletes chosen beer", %{conn: conn, beer: beer} do
      conn = delete(conn, Routes.beer_path(conn, :delete, beer))
      assert redirected_to(conn) == Routes.beer_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.beer_path(conn, :show, beer))
      end
    end
  end

  defp create_beer(_) do
    beer = beer_fixture()
    %{beer: beer}
  end
end
