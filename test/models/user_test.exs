defmodule HelloPhoenix.UserTest do
  use HelloPhoenix.ModelCase

  alias HelloPhoenix.User

  @valid_attrs %{bio: "Life info.", email: "email@example.com", name: "User Name", number_of_pets: 4}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "number_of_pets is not required" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :number_of_pets))
    assert changeset.valid?
  end

  test "bio must be at least two characters long" do
    attrs = %{@valid_attrs | bio: "L"}
    assert {:bio, "should be at least 2 character(s)"} in errors_on(%User{}, attrs)
  end

  test "bio must be at most 140 characters long" do
    attrs = %{@valid_attrs | bio: long_string(141)}
    assert {:bio, "should be at most 140 character(s)"} in errors_on(%User{}, attrs)
  end

  test "email must contain at least an @" do
    attrs = %{@valid_attrs | email: "email.example.com"}
    assert {:email, "has invalid format"} in errors_on(%User{}, attrs)
  end
end
