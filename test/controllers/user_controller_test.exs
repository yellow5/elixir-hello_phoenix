defmodule HelloPhoenix.UserControllerTest do
  use HelloPhoenix.ConnCase

  alias HelloPhoenix.User
  @valid_attrs %{bio: "Life info.", email: "email@example.com", name: "User Name", number_of_pets: 4}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing users"
  end

  test "lists all entries on /api/users", %{conn: conn} do
    # Populate some user resources.
    users = [ User.changeset(%User{}, %{@valid_attrs | email: "email1@example.com"}),
              User.changeset(%User{}, %{@valid_attrs | email: "email2@example.com"}) ]
    Enum.each(users, &Repo.insert!(&1))

    response = get(conn, "/api/users")
               |> json_response(200)

    expected = %{
      "data" => [
        %{ "bio" => "Life info.", "email" => "email1@example.com", "name" => "User Name", "number_of_pets" => 4 },
        %{ "bio" => "Life info.", "email" => "email2@example.com", "name" => "User Name", "number_of_pets" => 4 }
      ]
    }
    assert response == expected
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == user_path(conn, :index)
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New user"
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Show user"
  end

  test "responds with user if found by /api/users/:id", %{conn: conn} do
    user = User.changeset(%User{}, %{@valid_attrs | name: "Existing User", email: "existing@email.com"})
           |> Repo.insert!

    response = get(conn, "/api/users/" <> to_string(user.id))
               |> json_response(200)

    expected = %{
      "data" => %{
        "bio" => "Life info.", "email" => "existing@email.com", "name" => "Existing User", "number_of_pets" => 4
      }
    }
    assert response == expected
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :edit, user)
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert redirected_to(conn) == user_path(conn, :show, user)
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = delete conn, user_path(conn, :delete, user)
    assert redirected_to(conn) == user_path(conn, :index)
    refute Repo.get(User, user.id)
  end
end
