defmodule PhoenixDown.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
  	create unique_index(:users, [:curp])
  end
end
