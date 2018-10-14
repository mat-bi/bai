defmodule Bai.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Bai.Repo

  schema "messages" do
    field :content, :string

    belongs_to :user, Bai.User
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:content, :user_id])
      |> validate_required([:content, :user_id])
  end
end