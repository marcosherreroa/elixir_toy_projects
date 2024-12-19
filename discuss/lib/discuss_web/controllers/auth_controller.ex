defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.User
  alias Discuss.Repo
  import Ecto.Query

  defp getAndUpdateUser(email,provider,token) do
    case Repo.one(from user in User, where: user.email == ^email) do
      nil -> %User{}
      user -> user
    end
    |> User.changeset(%{"email" => email, "provider" => provider, "token" => token})
    |> Repo.insert_or_update!
  end

  def callback(conn, %{"provider" => provider}) do
    email = conn.assigns.ueberauth_auth.info.email
    token = conn.assigns.ueberauth_auth.credentials.token
    put_flash(conn, :info, "Signed in as #{email}")

    # Insert the user in the database or update it, assuming the email is the primary key
    user = getAndUpdateUser(email,provider,token)

    conn
    |> put_session(:user_id, user.id) # Store the user id in the cookies
    |> put_flash(:info, "Signed in as #{user.email}") # Notify the user
    |> redirect(to: ~p"/") # Redirect to main page
  end

  def signout(conn,_params) do
    conn
    #|> delete_session(:user_id)
    |> configure_session(drop: true)
    |> redirect(to: ~p"/")
  end
end
