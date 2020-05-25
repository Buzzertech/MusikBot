defmodule Musikbot.TrackScout.Track do
  defstruct [:id, :stream_url, :user, :title, :tag_list, :duration]

  @expected_fields ~w(
    id user title tag_list duration permalink_url media
  )

  defp get_soundcloud_api(url),
    do: "#{Application.get_env(:musikbot, :soundcloud)[:origin]}#{url}"

  defp get_track_api_path(track_id),
    do:
      Application.get_env(:musikbot, :soundcloud)[:get_track_api] |> get_soundcloud_api()

  defp put_stream_url_to_map(stream_url, map), do: map |> Map.put("stream_url", stream_url)

  defp is_suitable_transcoding(%{ "format" => format }) do
    case format do
      %{"protocol" => "progressive", "mime_type" => "audio/mpeg"} ->
        true
      _ ->
        false
    end
  end

  defp get_headers(),
    do: [
      params: [client_id: Application.get_env(:musikbot, :soundcloud)[:client_id]]
    ]

  @spec get_track_from_soundcloud(number) :: Map.t()
  def get_track_from_soundcloud(track_id) do
    headers = [
      params: [
        ids: [track_id],
        client_id: Application.get_env(:musikbot, :soundcloud)[:client_id]
      ]
    ]

    response =
      track_id
      |> get_track_api_path()
      |> HTTPoison.get(headers, [])

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Poison.decode!()
        |> Enum.at(0)
        |> Map.take(@expected_fields)

      {:error, %HTTPoison.Response{status_code: 404, body: _body}} ->
        raise "Track not found"

      {:error, %HTTPoison.Response{status_code: 403, body: _body}} ->
        raise "Access forbidden"

      otherwise ->
        raise "Something went wrong while fetching track #{track_id}"
    end
  end

  @spec get_track_with_stream_url(String.t()) :: Map.t()
  def get_track_with_stream_url(track_id) do
    track =
      track_id
      |> get_track_from_soundcloud()

    track
    |> Map.get("media")
    |> Map.get("transcodings", [])
    |> Enum.find(&is_suitable_transcoding/1)
    |> Map.get("url")
    |> put_stream_url_to_map(track)
  end
end
