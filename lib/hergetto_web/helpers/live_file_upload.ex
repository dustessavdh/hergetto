defmodule HergettoWeb.Helpers.LiveUpload do
  alias Phoenix.LiveView
  alias Phoenix.LiveView.UploadEntry
  alias HergettoWeb.Router.Helpers, as: Routes

  def save_image(socket, folder_location \\ "") do
    uploaded_files =
      LiveView.consume_uploaded_entries(socket, :profile_picture, fn %{path: path}, entry ->
        destination = get_file_destination(folder_location)
        filename = get_filename(entry)
        full_destination = Path.join(destination, filename)

        File.mkdir_p!(destination)
        File.cp!(path, full_destination)
        {:ok, Routes.static_path(socket, "/uploads/#{folder_location}/#{filename}")}
      end)

    {:ok, uploaded_files}
  end

  # Move to helper file for live uploads
  defp get_file_destination(folder_location) do
    Path.join("priv/static/uploads", folder_location)
  end

  defp get_filename(entry) do
    entry.client_name
    |> String.replace_prefix("", get_file_prefix(entry))
    |> String.replace(~r/[^a-zA-Z0-9_\-\.\s]/, "")
    |> beautify_filename()
  end

  defp get_file_prefix(%UploadEntry{:uuid => uuid}) do
    uuid
    |> String.split("-")
    |> List.last()
    |> String.replace_suffix("", "_")
  end

  defp beautify_filename(filename) do
    filename
    |> String.replace(~r/-+/, "-")
    |> String.replace(~r/\s+/, "_")
    |> String.replace(~r/_+/, "_")
    |> String.replace(~r/-*\.-*/, ".")
    |> String.replace(~r/\.{2,}/, ".")
    |> String.downcase()
    |> String.trim(".-")
  end
end
