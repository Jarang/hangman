defmodule Hangman.Runtime.Server do
  @type t :: pid()
  # 1 hour
  @idle_timeout 1 * 60 * 60 * 1000

  alias Hangman.Runtime.Watchdog
  alias Hangman.Impl.Game
  use GenServer

  ### client process

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  ### server process

  def init(_) do
    IO.puts("Starting a new game")
    watcher = Watchdog.start(@idle_timeout)
    {:ok, {Game.new_game(), watcher}}
  end

  def handle_call({:make_move, guess}, _from, {game, watcher}) do
    Watchdog.im_alive(watcher)
    {updated_game, tally} = Game.make_move(game, guess)
    {:reply, tally, {updated_game, watcher}}
  end

  def handle_call({:tally}, _from, {game, watcher}) do
    Watchdog.im_alive(watcher)
    {:reply, Game.tally(game), {game, watcher}}
  end
end
