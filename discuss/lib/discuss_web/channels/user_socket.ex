defmodule DiscussWeb.UserSocket do
  use Phoenix.Socket

  channel "comments:*", DiscussWeb.CommentsChannel

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket,"key",token) do
      {:ok, user_id} ->
        {:ok, assign(socket,:user_id,user_id)}
      {:error, cause} ->
        {:error, cause}
    end
  end

  @impl true
  def id(_socket), do: nil
end
