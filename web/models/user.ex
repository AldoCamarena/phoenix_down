defmodule PhoenixDown.User do
  use PhoenixDown.Web, :model

  alias Openmaize.Signup

  schema "users" do
    field :curp, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :edad, :integer
    field :sexo, :string
    field :estatura, :float
    field :peso, :float
    field :cintura, :float
    field :colesterol, :string
    field :role, :string, default: "user"
    field :apaterno, :string
    field :amaterno, :string
    field :nombre, :string
    field :email, :string
    field :nss, :string

    timestamps
  end

  @required_fields ~w(nss password email)
  @optional_fields ~w(curp edad sexo estatura peso cintura colesterol role apaterno amaterno nombre)

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
end
