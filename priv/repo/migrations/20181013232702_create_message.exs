defmodule Bai.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
