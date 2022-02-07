defmodule Hergetto.Chats do
  @moduledoc false
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

  @doc false
  def get(chat_service, scope) do
    case chat_service |> exists() do
      true ->
        pid = Process.whereis(chat_service |> generate_chat_service_id())
        GenServer.call(pid, {:get, scope})

      false ->
        :nochatservice
    end
  end

  @doc false
  def get_all(chat_service) do
    chat_service |> get(:all)
  end

  @doc false
  def get_messages(chat_service) do
    chat_service |> get(:messages)
  end

  @doc false
  def get_room(chat_service) do
    chat_service |> get(:room)
  end

  @doc """
  Check if the specified `chat_service` exists.
  
  Returns `true` or `false`.
  
  ## Examples
  
      iex> Chats.exists("93a628cc-cec1-4733-b513-aff5824b02da")
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

  @doc false
  defp generate_chat_service_id(chat_service) do
    :"chat_service:#{chat_service}"
  end
end
