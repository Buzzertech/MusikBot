defmodule Musikbot.TrackScout.TrackTest do
  use ExUnit.Case

  import Mock

  doctest Musikbot.TrackScout.Track

  describe "get_track_from_soundcloud" do
    setup do
      transcoding = %{
        "url" => "https://example-stream.com/",
        "preset" => "mp3_0_1",
        "duration" => 139_886,
        "snipped" => false,
        "format" => %{
          "protocol" => "progressive",
          "mime_type" => "audio/mpeg"
        },
        "quality" => "sq"
      }

      success_response =
        [
          %{
            "id" => "7000",
            "tags_list" => ["cool", "song"],
            "media" => %{
              "transcodings": [transcoding]
            },
            "user" => %{
              username: "Bvzzi",
              permalink_url: "https://soundcloud.com/bvzzi"
            },
            "permalink_url" => "https://soundcloud.com/track/7000"
          }
        ]
        |> Poison.encode!()

      {:ok, success_response: success_response}
    end

    test "should fetch track from soundcloud successfully", %{success_response: success_response} do
      with_mock HTTPoison,
        get: fn _api, _headers, _opts ->
          {:ok, %HTTPoison.Response{status_code: 200, body: success_response}}
        end do
        {:ok, %{"id" => id, "permalink_url" => permalink_url, "stream_url" => stream_url}} =
          Musikbot.TrackScout.Track.get_track_from_soundcloud(7000)

        assert id == "7000"
        assert permalink_url == "https://soundcloud.com/track/7000"
        assert stream_url == "https://example-stream.com/"
      end
    end

    test "should raise an exception if track wasn't found" do
      with_mock HTTPoison,
        get: fn _api, _headers, _opts ->
          {:error, %HTTPoison.Response{status_code: 404, body: nil}}
        end do
        {:error, "Something went wrong while fetching track 7000"} = Musikbot.TrackScout.Track.get_track_from_soundcloud(7000)
      end
    end
  end
end
