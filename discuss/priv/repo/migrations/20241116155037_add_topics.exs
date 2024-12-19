defmodule Discuss.Repo.Migrations.AddTopics do
  use Ecto.Migration
  import Ecto.Changeset

  def change do
    create table(:topics) do
      add :title, :string
    end
  end
end
