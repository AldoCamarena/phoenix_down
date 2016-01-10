defmodule PhoenixDown.UserController do
  use PhoenixDown.Web, :controller

  alias PhoenixDown.User

  import BigDataConnection

  plug :scrub_params, "user" when action in [:create, :update]

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params} = params) do
    changeset = User.auth_changeset(%User{}, user_params)

    if tiene_derecho(:curp, Map.get(user_params, "curp")) or tiene_derecho(:nss, Map.get(user_params, NSS)) do
      case Repo.insert(changeset) do
        {:ok, user} ->
          conn
          |> put_status(:created)
          |> put_resp_header("location", user_path(conn, :show, user))
          |> render("show.json", user: user)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(PhoenixDown.ChangesetView, "error.json", changeset: changeset)
      end
    else
      conn
      |> send_resp(:forbidden, "{\"error\": \"Sin derecho a servicios de seguro social\"}")
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixDown.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end

  def me(%Plug.Conn{assigns: %{current_user: %{id: id}}} = conn, opts) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def me(conn, _params) do
    send_resp(conn, :unauthorized, "{error: \"No token\"}")
  end
end
