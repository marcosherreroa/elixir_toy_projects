defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel
  alias Discuss.{Repo, Topic, Comment}
  import Ecto.Query

  @impl true
  def join("comments:" <> topic_id, _payload, socket) do
    topic = Repo.one!(from topic in Topic, where: topic.id == ^topic_id, preload: [comments: :user])
    {:ok, %{comments: topic.comments},assign(socket,:topic,topic)}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("add_comment", payload, socket) do
    topic = socket.assigns.topic
    changeset = topic
    |> Ecto.build_assoc(:comments, user_id: socket.assigns.user_id)
    |> Comment.changeset(payload)

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket,"new_comment",%{comment: comment})
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (comments:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
