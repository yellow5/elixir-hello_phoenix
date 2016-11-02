defmodule HelloPhoenix.RoomChannelTest do
  use HelloPhoenix.ChannelCase

  alias HelloPhoenix.RoomChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(RoomChannel, "room:lobby")

    {:ok, socket: socket}
  end

  test "new_msg broadcasts to room:lobby", %{socket: socket} do
    push socket, "new_msg", %{"body" => "hello all"}
    assert_broadcast "new_msg", %{body: "hello all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "new_msg", %{"some" => "data"}
    assert_push "new_msg", %{"some" => "data"}
  end
end
