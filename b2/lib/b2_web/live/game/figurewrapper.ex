defmodule B2Web.Live.Game.Figurewrapper do
  use B2Web, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <%= if @version == "graphic" do %>
        <%= live_component(B2Web.Live.Game.Figure, tally: assigns.tally, id: 99) %>
      <% else %>
        <%= live_component(B2Web.Live.Game.StickFigure, tally: assigns.tally, id: 98) %>
      <% end %>
    </div>
    """
  end
end
