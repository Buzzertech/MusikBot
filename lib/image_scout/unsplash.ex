defmodule Musikbot.ImageScout.Unsplash do
  @moduledoc """
  Fetches a random image from an image library and then generates the static background for the video
  """

  @expected_fields ~w(
    id image_url user
  )

  defp extract_image_url(unsplash_image) do
    image_url =
      unsplash_image
      |> Kernel.get_in(["urls", "custom"])

    unsplash_image |> Map.put("image_url", image_url)
  end

  defp get_unsplash_client_id(unsplash_config), do: unsplash_config |> Keyword.get(:client_id)

  defp get_unsplash_url(unsplash_config) do
    origin = unsplash_config |> Keyword.get(:origin)
    get_random_photo_api = unsplash_config |> Keyword.get(:get_random_photo_api)

    "#{origin}#{get_random_photo_api}"
  end

  @spec fetch_image_from_unsplash :: {:error, any()} | {:fatal_error, any()} | {:ok, map}
  def fetch_image_from_unsplash() do
    unsplash_config = Application.get_env(:musikbot, :unsplash)

    headers = [
      params: [
        client_id: unsplash_config |> get_unsplash_client_id(),
        orientation: "landscape",
        w: 1920,
        h: 1080
      ]
    ]

    response =
      unsplash_config
      |> get_unsplash_url()
      |> HTTPoison.get(headers, [])

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        image_data =
          body
          |> Poison.decode!()
          |> extract_image_url()
          |> Map.take(@expected_fields)

        {:ok, image_data}

      {:ok, %HTTPoison.Response{status_code: 404, body: error}} ->
        {:error, error}

      {:ok, %HTTPoison.Response{status_code: 500, body: error}} ->
        {:fatal_error, error}

      {:error, error} ->
        {:fatal_error, error}
    end
  end
end
