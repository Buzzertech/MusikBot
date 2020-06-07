defmodule Musikbot.TrackScout.Scout do
  use GenServer

  alias Musikbot.TrackScout.{Track}

  @max_track_id 784_514_266

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def fetch_random_track(server) do
    GenServer.cast(server, {:fetch_random_track})
  end

  def get_random_track(server) do
    {:ok, track_data} = GenServer.call(server, {:get_track_state}, 5000)
    track_data
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:fetch_random_track}, state) do
    random_track_id = 700_000_000..@max_track_id |> Enum.random()

    case Track.get_track_from_soundcloud(random_track_id) do
      {:ok, track} ->
        {:noreply, state |> Map.merge(%{track_data: track})}

      {:error, error} ->
        IO.puts(error)
        {:noreply, state}
    end
  end

  @impl true
  def handle_call({:get_track_state}, _from, state) do
    {:reply, Map.fetch(state, :track_data), state}
  end
end
