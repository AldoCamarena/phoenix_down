defmodule PhoenixDown.User do
  use PhoenixDown.Web, :model

  alias Openmaize.Signup
  alias PhoenixDown.UserStatus

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

    # Riegos del 1 al 10
    field :riesgo_colesterol, :integer, default: 5
    field :riesgo_diabetes, :integer, default: 5
    field :riesgo_rinones, :integer, default: 5
    field :riesgo_cancer_mama, :integer, default: 5
    field :riesgo_hipertension, :integer, default: 5
    field :riesgo_cancer_colon, :integer, default: 5

    embeds_many :statuses, UserStatus

    timestamps
  end

  @required_fields ~w(curp fecha_nacimiento)
  @optional_fields ~w(apaterno password_hash amaterno nombre sexo role email nss statuses riesgo_colesterol riesgo_diabetes riesgo_rinones riesgo_cancer_mama riesgo_hipertension riesgo_cancer_colon)

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
    changes = changeset(model, params)
    status = UserStatus.changeset(%UserStatus{}, user_status)

    put_embed(changes, :statuses, [status | model.statuses])
  end

  def get_last_status(user) do
    Enum.max_by(user.statuses, fn(s) -> s.inserted_at end)
  end
end
