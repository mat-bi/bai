defmodule Bai.Permission do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Bai.Repo

  schema "permissions" do
    belongs_to :user, Bai.User
    belongs_to :message, Bai.Message

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:user_id, :message_id])
      |> validate_required([:user_id, :message_id])
  end

  def add!(username, message_id) do
    unless is_nil(username) and is_nil(message_id) do
      user_id = Repo.get_by(Bai.User, username: username).id

      changeset(%__MODULE__{}, %{user_id: user_id, message_id: message_id}) |> Repo.insert!()
    end
  end

  def revoke(username, message_id) do
    unless is_nil(username) and is_nil(message_id) do
      user_id = Repo.get_by(Bai.User, username: username).id

      (from permission in __MODULE__,
      where: permission.message_id == ^message_id
      and permission.user_id == ^user_id)
      |> Repo.delete_all
    end
  end

  def list(message_id) do
    Repo.all(from permission in __MODULE__,
            left_join: user in assoc(permission, :user),
            where: permission.message_id == ^message_id,
            select: %{username: user.username})
  end

  def permitted?(user_id, message_id) do
    permissions =
      (from p in __MODULE__,
      where: p.message_id == ^message_id
      and p.user_id == ^user_id,
      select: 1)

    owner_id = Repo.get!(Bai.Message, message_id).user_id

    owner_id == user_id or not Enum.empty?(Repo.all(permissions))
  end
end