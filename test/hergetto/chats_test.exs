defmodule Hergetto.ChatsTest do
  use ExUnit.Case
  alias Hergetto.Chats
  alias Hergetto.Rooms
  alias Hergetto.Structs.Message
  alias Hergetto.Structs.RoomEvent

  test "a chat service" do
    {:ok, chat_service} = Chats.create(nil)
    assert chat_service != nil
  end

  test "send a message" do
    {:ok, chat_service} = Chats.create(nil)
    chat_service |> Chats.send(%Message{})
    messages = chat_service |> Chats.get_messages()
    assert length(messages) == 1
  end

  test "Recieve event on message send" do
    {:ok, room} = Rooms.create()
    room |> Rooms.join()
    chat_service = room |> Rooms.get_chat_service()
    chat_service |> Chats.send(%Message{})
    assert_receive(%RoomEvent{})
  end
end
