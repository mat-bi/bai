defmodule BaiWeb.PageController do
  use BaiWeb, :controller
  alias Bai.Repo
  alias Bai.{Message, User, Permission}

  plug :check_logged when action in [:index, :act]
  plug :check_credentials when action == :act

  def index(conn, _params) do
    render conn, "index.html", username: get_session(conn, :username), messages: Message.list_all(get_session(conn, :username))
  end

  def login(conn, _) do
    render conn, "login.html"
  end

  def logout(conn, _) do
    conn
      |> delete_session(:username)
      |> redirect(to: page_path(conn, :index))
  end

  def act(conn, %{"action" => action, "par" => par} = params) do
    case action do
      "Dodaj" -> Message.changeset(%Message{}, %{content: par, user_id: Repo.get_by!(User, username: get_session(conn, :username)).id})
                  |> Repo.insert!()
      "Usuń" -> Repo.delete!(Repo.get!(Message, par))
      "Edytuj" -> Repo.update!(Message.changeset(Repo.get!(Message, params["par2"]), %{content: par}))
      "Dodaj_uprawnienie" -> Permission.add!(params["par2"], params["par"])
      "Odbierz" -> Permission.revoke(params["par2"], params["par"])
    end
    redirect conn, to: page_path(conn, :index)
  end

  def log_in(conn, %{"username" => username, "password" => password }) do
    case Bai.User.login(username, password) do
      %Bai.User{} -> conn |> put_session(:username, username) |> redirect(to: page_path(conn, :index))
      nil -> redirect conn, to: page_path(conn, :index)
    end
  end

  def edit(conn, %{"id" => id}) do
    render conn, message: Repo.get!(Message, id)
  end

  defp check_logged(conn, _) do
    case get_session(conn, :username) do
      nil -> redirect conn, to: page_path(conn, :login)
      _ -> conn
    end
  end

  def register(conn, _) do
    render conn, "register.html"
  end

  def register_post(conn, %{"username" => username, "password" => password}) do
    case Repo.insert(User.changeset(%User{}, %{username: username, password: password })) do
      {:ok, %User{}} -> put_session(conn, :username, username) |> redirect(to: page_path(conn, :index))
      _ -> render conn, "register.html"
    end
  end

  def permissions(conn, params) do
    render conn, "permissions.html", message_id: params["par"], permissions: Permission.list(params["par"])
  end

  defp check_credentials(conn, _) do
    case conn.params do
      %{"action" => "Usuń", "par" => id}  ->
        check(conn, id)
      %{"action" => "Edytuj", "par2" => id} ->
        check_permitted(conn, id)
      _ -> conn
    end
  end

  defp check(conn, id) do
    if Repo.get!(Message, id).user_id == Repo.get_by(User, username: get_session(conn, :username)).id do
      conn
    else
      put_status(conn, :unauthorized) |> halt()
    end
  end

  defp check_permitted(conn, id) do
    if Permission.permitted?(Repo.get_by(User, username: get_session(conn, :username)).id, id) do
      conn
    else
      put_status(conn, :unauthorized) |> halt()
    end
  end
end
