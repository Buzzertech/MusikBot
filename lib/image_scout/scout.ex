defmodule Musikbot.ImageScout.Scout do
  use GenServer

  alias Musikbot.ImageScout.{Unsplash}

  @impl true
  def init(:ok), do: {:ok, %{}}

  @impl true
  def handle_cast({:fetch_random_image}, state) do
    case Unsplash.fetch_image_from_unsplash() do
      {:ok, image_data} ->
        {:noreply, %{state | image_data: image_data}}

      {:error, error} ->
        IO.puts(error)

      {:fatal_error, error} ->
        IO.puts(error)
    end
  end

  @impl true
  def handle_call({:get_image_state}, _from, state) do
    {:reply, Map.fetch!(state, :image_data), state}
  end

  def save_to_disk(svg_string), do: Temp.open!("image.svg", &IO.write(&1, svg_string))

  def cleanup(), do: Temp.track!() |> Temp.cleanup()

  def fetch_random_image(server) do
    GenServer.cast(server, {:fetch_random_image})
  end

  def get_image_state(server) do
    {:ok, state} = GenServer.call(server, {:get_image_state}, 5000)
    state
  end

  @spec get_svg_from_template(%{track_data: map, image_data: map}) :: String.t()
  def get_svg_from_template(template_data),
    do: Mustache.render(Application.get_env(:musikbot, :misc)[:svg_template], template_data)
end
