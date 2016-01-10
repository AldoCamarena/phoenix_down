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
      edad: get_age(user.fecha_nacimiento),
      sexo: user.sexo,
      apaterno: user.apaterno,
      amaterno: user.amaterno,
      nombre: user.nombre,
      email: user.email,
      cuestionario_tomado: user.cuestionario_tomado,
      fecha_nacimiento: user.fecha_nacimiento,
      riesgo_colesterol: user.riesgo_colesterol,
      riesgo_diabetes: user.riesgo_diabetes,
      riesgo_rinones: user.riesgo_rinones,
      riesgo_cancer_mama: user.riesgo_cancer_mama,
      riesgo_hipertension: user.riesgo_hipertension,
      riesgo_cancer_colon: user.riesgo_cancer_colon,

      statuses: render_many(user.statuses, PhoenixDown.UserStatusView, "user_status.json")
    }
  end

  defp get_age(dob) do
    dob_in_days = dob
    |> Ecto.Date.to_erl
    |> :calendar.date_to_gregorian_days

    today_in_days = Ecto.Date.utc()
    |> Ecto.Date.to_erl
    |> :calendar.date_to_gregorian_days

    {age, _, _} = :calendar.gregorian_days_to_date(today_in_days - dob_in_days)
    age
  end
end
