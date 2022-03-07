defmodule Hergetto.Chats do
  @moduledoc """
  The chat service context.
  """
  alias Hergetto.Helpers.ServiceStartHelper
  alias Hergetto.Chats.ChatSupervisor
  alias Hergetto.Chats.ChatService
  alias Hergetto.Rooms

  @doc """
  This function creates a new chat_service.

  Returns `{:ok, uuid}`. This `uuid` represents a chat_service.

  ## Examples

      iex> Chats.create(nil)
      {:ok, "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"}

  """
  def create(room) do
    ServiceStartHelper.start(ChatSupervisor, ChatService, room)
  end

  @doc """
  This function sends a message in the chat service.

  Returns `:ok`.

  ## Examples

      iex> {:ok, chat} |>  Chats.create(nil)
      {:ok, "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"}
      iex> chat |> Chats.send(%Message{})
      :ok

  """
  def send(chat_service, message) do
    with true <- exists?(chat_service),
         pid <- Process.whereis(generate_chat_service_id(chat_service)) do
      GenServer.cast(pid, {:send, message})

      chat_service
      |> get_room()
      |> Rooms.trigger("message", message, __MODULE__)

      :ok
    else
      _ ->
        :nochatservice
    end
  end

  @doc false
  def get(chat_service, scope) do
    with true <- exists?(chat_service),
         pid <- Process.whereis(generate_chat_service_id(chat_service)) do
      GenServer.call(pid, {:get, scope})
    else
      _ ->
        :nochatservice
    end
  end

  @doc false
  def get_all(chat_service) do
    get(chat_service, :all)
  end

  @doc false
  def get_messages(chat_service) do
    get(chat_service, :messages)
  end

  @doc false
  def get_room(chat_service) do
    get(chat_service, :room)
  end

  @doc """
  Check if the specified `chat_service` exists?.

  Returns `true` or `false`.

  ## Examples

      iex> Chats.exists?("93a628cc-cec1-4733-b513-aff5824b02da")
      true

  """
  def exists?(chat_service) do
    state = Process.whereis(generate_chat_service_id(chat_service))
    is_pid(state)
  end

  @doc false
  defp generate_chat_service_id(chat_service) do
    :"chat_service:#{chat_service}"
  end
end
