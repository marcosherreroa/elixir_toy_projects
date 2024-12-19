defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias Discuss.Topic
  alias Discuss.Repo
  import Ecto.Query

  plug DiscussWeb.Plugs.RequireAuth when action in [
      :new,
      :create,
      :edit,
      :update,
      :delete
    ]

  plug :check_topic_owner when action in [
    :edit,
    :update,
    :delete
  ]

  defp check_topic_owner(conn,_params) do
    %{"id" => id} = conn.params
    case Repo.get(Topic, id) do
      nil ->
        conn
        |> put_flash(:error, "Cannot find topic with id #{id}.")
        |> redirect(to: ~p"/")
        |> halt()
      topic ->
        if conn.assigns.user.id == topic.user_id do
          conn
        else
          conn
          |> put_flash(:error,"You don't have permission to perform that action!")
          |> redirect(to: ~p"/")
          |> halt()
    end

    end
  end

  def index(conn,_params) do
    topics = Repo.all(from topic in Topic, order_by: topic.id)
    render(conn,:index, topics: topics)
  end

  def new(conn,_params) do
    changeset = Topic.changeset(%Topic{})
    render(conn,:new_topic, changeset: changeset)
  end

  def create(conn,%{"topic" => params}) do
    changeset = conn.assigns.user
    |> Ecto.build_assoc(:topics)
    |> Topic.changeset(params)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: ~p"/")
      {:error, changeset} ->
        render(conn, :new_topic, changeset: changeset)
    end
  end

  def edit(conn,%{"id" => id}) do
    case Repo.get(Topic, id) do
      nil ->
        conn
        |> put_flash(:error, "Cannot find topic with id #{id}.")
        |> redirect(to: ~p"/")
      topic ->
        changeset = Topic.changeset(topic)
        render(conn, :edit_topic, changeset: changeset)
    end
  end

  def show(conn,%{"id" => id}) do
    case Repo.get(Topic, id) do
      nil ->
        conn
        |> put_flash(:error, "Cannot find topic with id #{id}.")
        |> redirect(to: ~p"/")
      topic ->
        render(conn, :show_topic, topic: topic)
    end
  end

  def update(conn,%{"id" => id, "topic" => params}) do
    changeset = Topic.changeset(%Topic{id: String.to_integer(id)}, params)
    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: ~p"/")
      {:error, changeset} ->
        render(conn,:edit_topic, changeset: changeset)
    end
  end

  def delete(conn,%{"id" => id}) do
    topic = Repo.get!(Topic,id)
    case Repo.delete(topic) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Topic Deleted")
        |> redirect(to: ~p"/")
      {:error, _} ->
        conn
        |> put_flash(:error, "Couldn't delete the topic")
        |> redirect(to: ~p"/")
    end

  end
end
