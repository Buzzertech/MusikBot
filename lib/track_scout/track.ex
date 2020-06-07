defmodule Musikbot.TrackScout.Track do
  @expected_fields ~w(
    id user title tags_list duration permalink_url stream_url
  )

  defp get_soundcloud_api(url),
    do: "#{Application.get_env(:musikbot, :soundcloud)[:origin]}#{url}"

  defp get_track_api_path(), do:
      Application.get_env(:musikbot, :soundcloud)[:get_track_api] |> get_soundcloud_api()

  defp put_stream_url_to_map(stream_url, map), do: map |> Map.put("stream_url", stream_url)

  defp is_suitable_transcoding(%{ "format" => format }) do
    case format do
      %{"protocol" => "progressive", "mime_type" => "audio/mpeg"} ->
        true
      nil ->
        false
    end
  end

  defp add_stream_url_from_transcodings(track) do
    track
    |> Map.get("media")
    |> Map.get("transcodings", [])
    |> Enum.find(&is_suitable_transcoding/1)
    |> Map.get("url")
    |> put_stream_url_to_map(track)
  end

  @spec get_track_from_soundcloud(number) :: {:ok, Map.t()} | {:error, String.t()}
  def get_track_from_soundcloud(track_id) do
    headers = [
      params: [
        ids: [track_id],
        client_id: Application.get_env(:musikbot, :soundcloud)[:client_id]
      ]
    ]

    response =
      get_track_api_path()
      |> HTTPoison.get(headers, [])

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        track = body
        |> Poison.decode!()
        |> Enum.at(0)
        |> add_stream_url_from_transcodings()
        |> Map.take(@expected_fields)

        {:ok, track}

      {:error, _} ->
        {:error, "Something went wrong while fetching track #{track_id}"}
    end
  end
end
