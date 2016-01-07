defmodule PhoenixDown.UserStatus do
  use PhoenixDown.Web, :model

  embedded_schema do
    field :estatura, :float
    field :peso, :float
    field :colesterol, :string
    field :consumo_alcohol, :integer
    field :consumo_cigarro, :integer
    field :estilo_de_vida, :integer

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(estatura peso colesterol consumo_alcohol consumo_cigarro estilo_de_vida)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end

# Ecto.Changeset.put_embed(changeset2, :statuses, [%User.UserStatus{"peso": 65.0} | user.statuses]) 