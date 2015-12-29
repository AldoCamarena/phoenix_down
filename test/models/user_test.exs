defmodule PhoenixDown.UserTest do
  use PhoenixDown.ModelCase

  alias PhoenixDown.User

  @valid_attrs %{amaterno: "some content", apaterno: "some content", cintura: "120.5", colesterol: "some content", curp: "some content", edad: 42, estatura: "120.5", nombre: "some content", password: "some content", peso: "120.5", role: "some content", sexo: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
