defmodule Bai.User do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias Bai.Repo

  schema "users" do
    field :username, :string
    field :password, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
    |> unique_constraint(:username)
  end

  def login(username, password) do
    query = from user in __MODULE__,
              where: user.username == ^username
              and user.password == ^password
    Repo.one(query)
  end
end
