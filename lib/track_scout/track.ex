defmodule Musikbot.Track do
  use HTTPoison.Base

  defstruct [:id, :stream_url, :user, :title, :tag_list, :duration]

  @expected_fields ~w(
    id user title tag_list duration
  )

  defp get_track_api_path(track_id), do: "#{Application.get_env(:musikbot, :soundcloud)[:get_track_api]}/#{track_id}"

  defp put_stream_url_to_map(stream_url, map), do: map |> Map.put(:stream_url, stream_url)

  @spec get_transcoding(number) :: String.t()
  def get_transcoding(track) do

  end

  @spec get_track_from_soundcloud(number) :: String.t()
  def get_track_from_soundcloud(track_id) do
    headers = [
      "params": ["client_id": Application.get_env(:musikbot, :soundcloud)[:client_id]]
    ]

    response = track_id
      |> get_track_api_path()
      |> Musikbot.Track.get()

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, "body": body }} ->
        track = body
          |> get_transcoding()
          |> put_stream_url_to_map(body)
        {:ok, track}
      {:error, %HTTPoison.Response{status_code: 404, "body": _body}} ->
        {:not_found}
      {:error, %HTTPoison.Response{status_code: 403, "body": _body}} ->
        {:forbidden}
    end
  end

  def process_request_url(url), do: "#{Application.get_env(:musikbot, :soundcloud)[:origin]}#{url}"

  def process_response_body(body) do
    body
    |> Poison.decode!()
    |> Map.take(@expected_fields)
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  end
end
