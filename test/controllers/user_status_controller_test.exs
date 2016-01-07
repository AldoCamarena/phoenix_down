defmodule PhoenixDown.UserStatusControllerTest do
  use PhoenixDown.ConnCase

  alias PhoenixDown.UserStatus
  @valid_attrs %{colesterol: "some content", consimo_cigarro: 42, consumo_alcohol: 42, estatura: "120.5", estilo_de_vida: 42, peso: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_status_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user_status = Repo.insert! %UserStatus{}
    conn = get conn, user_status_path(conn, :show, user_status)
    assert json_response(conn, 200)["data"] == %{"id" => user_status.id,
      "estatura" => user_status.estatura,
      "peso" => user_status.peso,
      "colesterol" => user_status.colesterol,
      "consumo_alcohol" => user_status.consumo_alcohol,
      "consimo_cigarro" => user_status.consimo_cigarro,
      "estilo_de_vida" => user_status.estilo_de_vida}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, user_status_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_status_path(conn, :create), user_status: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(UserStatus, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_status_path(conn, :create), user_status: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user_status = Repo.insert! %UserStatus{}
    conn = put conn, user_status_path(conn, :update, user_status), user_status: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(UserStatus, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user_status = Repo.insert! %UserStatus{}
    conn = put conn, user_status_path(conn, :update, user_status), user_status: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user_status = Repo.insert! %UserStatus{}
    conn = delete conn, user_status_path(conn, :delete, user_status)
    assert response(conn, 204)
    refute Repo.get(UserStatus, user_status.id)
  end
end
