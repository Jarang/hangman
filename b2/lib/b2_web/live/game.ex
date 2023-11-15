defmodule B2Web.Live.Game do
  use B2Web, :live_view

  def mount(_params, _session, socket) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)

    socket =
      socket
      |> assign(%{game: game, tally: tally, version: "graphic"})

    {:ok, socket}
  end

  def handle_event("make_move", %{"key" => key}, socket) do
    tally = Hangman.make_move(socket.assigns.game, key)
    {:noreply, assign(socket, :tally, tally)}
  end

  def handle_event("switch_view", %{"version" => "graphic"}, socket) do
    {:noreply, assign(socket, :version, "stickfigure")}
  end

  def handle_event("switch_view", %{"version" => "stickfigure"}, socket) do
    {:noreply, assign(socket, :version, "graphic")}
  end

  def render(assigns) do
    ~H"""
    <button
      class=""
      phx-click="switch_view"
      phx-value-version={assigns.version}
    >
      <%= if @version == "graphic", do: "Switch to Stickfigure", else: "Switch to graphics" %>
    </button>
    <div class="game-holder" phx-window-keyup="make_move">
      <%= live_component(__MODULE__.Figurewrapper, %{tally: assigns.tally, version: assigns.version}, id: 1) %>
      <%= live_component(__MODULE__.Alphabet, tally: assigns.tally, id: 2) %>
      <%= live_component(__MODULE__.WordSoFar, tally: assigns.tally, id: 3) %>
    </div>
    """
  end
end
