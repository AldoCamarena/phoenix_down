defmodule PhoenixDown.UserStatusController do
  use PhoenixDown.Web, :controller

  alias PhoenixDown.UserStatus
  alias PhoenixDown.User

  plug :scrub_params, "user_status" when action in [:create, :update]

  def index(conn, %{"user_id" => user}) do
    user = Repo.get!(User, user)

    render(conn, "index.json", user_statuses: user.statuses)
  end

  def create(conn, %{"user_id" => user_id, "user_status" => _user_status_params} = params) do
    IO.inspect(params);

    user = Repo.get!(User, user_id)
    changeset = User.insert_status_changeset(user, params)

    case Repo.update(changeset) do
      {:ok, user} ->
        user_status = User.get_last_status(user)
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_status_path(conn, :show, user, user_status)) #Not Concurrency Safe
        |> render("show.json", user_status: user_status)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixDown.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    user_status = get_user_status(user_id, id)

    render(conn, "show.json", user_status: user_status)
  end

  def update(conn, %{"user_id" => _user_id, "id" => id, "user_status" => user_status_params}) do
    user_status = Repo.get!(UserStatus, id)
    changeset = UserStatus.changeset(user_status, user_status_params)

    case Repo.update(changeset) do
      {:ok, user_status} ->
        render(conn, "show.json", user_status: user_status)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixDown.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => id}) do
    user = Repo.get!(User, user_id)
    changeset = User.delete_status_changeset(user, id)

    case Repo.update(changeset) do
      {:ok, _user} ->
        send_resp(conn, :no_content, "")
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixDown.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp get_user_status(user_id, status_id) do
    Enum.find(Repo.get!(User, user_id).statuses, fn(status) -> status.id == status_id end)
  end
end
