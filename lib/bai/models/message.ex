defmodule Bai.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Bai.Repo

  schema "messages" do
    field :content, :string

    belongs_to :user, Bai.User

    field :permitted, :boolean, virtual: true

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:content, :user_id])
      |> validate_required([:content, :user_id])
  end

  def list_all(username) do
    user_id = Repo.get_by!(Bai.User, username: username).id

    messages = Repo.all(
      from m in __MODULE__,
      left_join: u in assoc(m, :user),
      select: %{id: m.id, content: m.content, inserted_at: m.inserted_at, username: u.username}
    )

    Enum.map(
      messages,
      fn(m) ->
        Map.put(m, :permitted, Bai.Permission.permitted?(user_id, m.id))
      end
    )
  end
end