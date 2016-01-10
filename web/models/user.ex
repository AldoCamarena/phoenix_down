defmodule PhoenixDown.User do
  use PhoenixDown.Web, :model

  alias Openmaize.Signup
  alias PhoenixDown.UserStatus

  import MotorDeRiesgosConnection
  import BigDataConnection

  schema "users" do
  ##Permanente (no historical storage)
    field :curp, :string #
    field :apaterno, :string ##
    field :amaterno, :string ##
    field :nombre, :string ##
    field :password, :string, virtual: true #
    field :password_hash, :string #
    field :sexo, :string ##
    field :role, :string, default: "user"
    field :email, :string ##
    field :nss, :string ##
    field :fecha_nacimiento, Ecto.Date #
    field :cuestionario_tomado, :boolean, default: false

    # Riegos del 1 al 10
    field :riesgo_colesterol, :integer, default: 5
    field :riesgo_diabetes, :integer, default: 5
    field :riesgo_rinones, :integer, default: 5
    field :riesgo_cancer_mama, :integer, default: 5
    field :riesgo_hipertension, :integer, default: 5
    field :riesgo_cancer_colon, :integer, default: 5

    embeds_many :statuses, UserStatus, [on_replace: :delete]

    timestamps
  end

  @required_fields ~w(curp fecha_nacimiento email)
  @optional_fields ~w(apaterno password_hash amaterno nombre sexo role nss statuses riesgo_colesterol
    riesgo_diabetes riesgo_rinones riesgo_cancer_mama riesgo_hipertension riesgo_cancer_colon
    cuestionario_tomado)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:curp)
  end

  def auth_changeset(model, params) do
    model
    |> changeset(params)
    |> Signup.create_user(params)
  end

  def insert_status_changeset(model, %{"user_status" => user_status} = params) do
    params = Map.merge(obtener_usuario(model.curp), user_status)
    |> obtener_riesgos
    |> Map.merge(params)

    changes = changeset(model, Map.put(params, "cuestionario_tomado", true))
    status = UserStatus.changeset(%UserStatus{}, user_status)

    put_embed(changes, :statuses, [status | model.statuses])
  end

  def delete_status_changeset(model, status_id) do
    statuses = Enum.reject(model.statuses, fn status -> status.id == status_id end)

    model
    |> change
    |> put_embed :statuses, statuses
  end

  def get_last_status(user) do
    Enum.max_by(user.statuses, fn(s) -> s.inserted_at end)
  end
end
