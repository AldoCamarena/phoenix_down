defmodule PhoenixDown.UserStatusView do
  use PhoenixDown.Web, :view

  def render("index.json", %{user_statuses: user_statuses}) do
    %{data: render_many(user_statuses, PhoenixDown.UserStatusView, "user_status.json")}
  end

  def render("show.json", %{user_status: user_status}) do
    %{data: render_one(user_status, PhoenixDown.UserStatusView, "user_status.json")}
  end

  def render("user_status.json", %{user_status: user_status}) do
    %{id: user_status.id,
      estatura: user_status.estatura,
      peso: user_status.peso,
      colesterol: user_status.colesterol,
      consumo_alcohol: user_status.consumo_alcohol,
      consumo_cigarro: user_status.consumo_cigarro,
      estilo_de_vida: user_status.estilo_de_vida}
  end
end
