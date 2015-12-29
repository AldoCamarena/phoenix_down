defmodule PhoenixDown.UserView do
  use PhoenixDown.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, PhoenixDown.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, PhoenixDown.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      curp: user.curp,
      edad: user.edad,
      sexo: user.sexo,
      estatura: user.estatura,
      peso: user.peso,
      cintura: user.cintura,
      colesterol: user.colesterol,
      apaterno: user.apaterno,
      amaterno: user.amaterno,
      nombre: user.nombre}
  end
end
