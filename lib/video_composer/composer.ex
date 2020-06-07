defmodule Musikbot.VideoComposer.Composer do
  use GenServer

  import FFmpex
  alias FFmpex.Options

  def start_link(opts), do: GenServer.start_link(__MODULE__, :ok, opts)

  def render_video(server, image_path, track_url, video_path),
    do: server |> GenServer.cast({:render_video, image_path, track_url, video_path})

  def get_status(server), do: server |> GenServer.call({:get_status}) |> elem(1)

  @impl true
  def init(:ok), do: {:ok, %{status: :not_started}}

  @impl true
  def handle_cast({:render_video, image_path, track_url, video_path}, state) do
    :ok =
      FFmpex.new_command()
      |> add_input_file(image_path)
      |> add_input_file(track_url)
      |> add_output_file(video_path)
      |> execute()

    {:noreply, state |> Map.merge(%{status: :rendered})}
  end

  @impl true
  def handle_call({:get_status}, _from, state), do: {:reply, state |> Map.fetch!(:status), state}
end
