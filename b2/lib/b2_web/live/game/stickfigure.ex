defmodule B2Web.Live.Game.StickFigure do
  use B2Web, :live_component

  def render(assigns) do
    ~H"""
      <div>
        <pre>
          <%= figure_for(@tally.turns_left) %>
        </pre>
      </div>
    """
  end

  defp figure_for(0) do
    ~s{
      +---+
      |   |
      O   |
     /|\\  |
     / \\  |
          |
    =========
    }
  end

  defp figure_for(1) do
    ~s{
      +---+
      |   |
      O   |
     /|\\  |
     /    |
          |
    =========
    }
  end

  defp figure_for(2) do
    ~s{
      +---+
      |   |
      O   |
     /|\\  |
          |
          |
    =========
    }
  end

  defp figure_for(3) do
    ~s{
      +---+
      |   |
      O   |
     /|   |
          |
          |
    =========
    }
  end

  defp figure_for(4) do
    ~s{
      +---+
      |   |
      O   |
      |   |
          |
          |
    =========
    }
  end

  defp figure_for(5) do
    ~s{
      +---+
      |   |
      O   |
          |
          |
          |
    =========
    }
  end

  defp figure_for(6) do
    ~s{
      +---+
      |   |
          |
          |
          |
          |
    =========
    }
  end

  defp figure_for(7) do
    ~s{
      +---+
          |
          |
          |
          |
          |
    =========
    }
  end
end
