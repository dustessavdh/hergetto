defmodule Hergetto.Chats do
  alias Hergetto.Helpers.ServiceStartHelper
  alias Hergetto.Chats.ChatSupervisor
  alias Hergetto.Chats.ChatService
  alias Hergetto.Rooms

  def create(room) do
    ServiceStartHelper.start(ChatSupervisor, ChatService, room)
  end

  def send(chat_service, message) do
    case chat_service |> exists() do
      true ->
        pid = Process.whereis(chat_service |> generate_chat_service_id())
        GenServer.cast(pid, {:send, message})
        chat_service
        |> get_room()
        |> Rooms.trigger("message", message, __MODULE__)
        :ok
      false ->
        :nochatservice
    end
  end

  def get(chat_service, scope) do
    case chat_service |> exists() do
      true ->
        pid = Process.whereis(chat_service |> generate_chat_service_id())
        GenServer.call(pid, {:get, scope})
      false ->
        :nochatservice
    end
  end

  def get_all(chat_service) do
    chat_service |> get(:all)
  end

  def get_messages(chat_service) do
    chat_service |> get(:messages)
  end

  def get_room(chat_service) do
    chat_service |> get(:room)
  end

  @doc """
  Check if the specified `room` exists.

  Returns `true` or `false`.

  ## Examples

      iex> Rooms.exists("93a628cc-cec1-4733-b513-aff5824b02da")
      true

  """
  def exists(chat_service) do
    case Process.whereis(chat_service |> generate_chat_service_id()) do
      nil ->
        false
      _ ->
        true
    end
  end

  defp generate_chat_service_id(chat_service) do
    :"chat_service:#{chat_service}"
  end
end
