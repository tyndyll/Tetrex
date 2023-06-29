defmodule TetrexWeb.Components.BoardComponents do
  use TetrexWeb, :html
  alias Tetrex.SparseGrid

  @doc """
  Board component. Assumes board size is 10x20.
  Have to hard code this rather than passing as attrs as Tailwind CSS
  cannot handle dynamic classes due to JIT compilation.
  This means you cannot do "grid-cols-# {num_cols}".
  """
  attr(:sparsegrid, :map, required: true)

  def board(assigns) do
    ~H"""
    <div class="grid grid-cols-10">
      <%= for y <- 0..19, x <- 0..9 do %>
        <.tile type={SparseGrid.get(@sparsegrid, y, x)} />
      <% end %>
    </div>
    """
  end

  @doc """
  Single tile box component. Assumes tile needs 4x4 grid to fit
  Have to hard code this rather than passing as attrs as Tailwind CSS
  cannot handle dynamic classes due to JIT compilation.
  This means you cannot do "grid-cols-# {num_cols}".
  """
  attr(:sparsegrid, :map, required: true)

  def single_tile(assigns) do
    ~H"""
    <% sparsegrid = centre_single_tile(@sparsegrid || SparseGrid.empty()) %>
    <div class="grid grid-cols-4">
      <%= for y <- 0..3, x <- 0..3 do %>
        <.tile type={SparseGrid.get(sparsegrid, y, x)} />
      <% end %>
    </div>
    """
  end

  attr(:title, :string, required: true)
  attr(:sparsegrid, :map, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def single_tile_box(assigns) do
    ~H"""
    <div class={["#{box_default_styles()} p-2", @class]} {@rest}>
      <%= @title %> <.single_tile sparsegrid={@sparsegrid} />
    </div>
    """
  end

  attr(:board, :map, required: true)
  attr(:class, :string, default: nil)

  def next_tile_box(assigns) do
    ~H"""
    <.single_tile_box title="Next" sparsegrid={@board.next_tile} class={@class} />
    """
  end

  attr(:board, :map, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def hold_tile_box(assigns) do
    ~H"""
    <.single_tile_box title="Hold" sparsegrid={@board.hold_tile} class={@class} {@rest} />
    """
  end

  attr(:board, :map, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def playfield(assigns) do
    ~H"""
    <div class={[box_default_styles(), @class]} {@rest}>
      <.board sparsegrid={@board.playfield} />
    </div>
    """
  end

  attr(:score, :integer, required: true)
  attr(:class, :string, default: nil)

  def score_box(assigns) do
    ~H"""
    <div class={"#{box_default_styles()} p-2 text-xl"}>
      Score: <%= @score %>
    </div>
    """
  end

  slot(:inner_block, required: true)

  def single_player_game_box(assigns) do
    ~H"""
    <div class="flex flex-col items-center bg-teal-500 pb-5">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr(:is_dead, :boolean, required: false, default: false)
  slot(:inner_block, required: true)

  def multiplayer_game(assigns) do
    ~H"""
    <div class={"#{if @is_dead, do: "bg-slate-400", else: " bg-teal-500 "} flex flex-col items-center border-2 border-double border-slate-400 px-3 pb-5"}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp centre_single_tile(tile), do: SparseGrid.align(tile, :centre, {0, 0}, {3, 3})

  defp box_default_styles,
    do:
      "m-1 h-fit w-fit rounded-md border-2 border-solid border-slate-700 bg-orange-100 text-center"

  attr(:type, :atom, required: true)

  defp tile(%{type: :red} = assigns) do
    ~H"""
    <.tile_filled class="fill-red-400" />
    """
  end

  defp tile(%{type: :green} = assigns) do
    ~H"""
    <.tile_filled class="fill-green-400" />
    """
  end

  defp tile(%{type: :blue} = assigns) do
    ~H"""
    <.tile_filled class="fill-blue-400" />
    """
  end

  defp tile(%{type: :cyan} = assigns) do
    ~H"""
    <.tile_filled class="fill-cyan-400" />
    """
  end

  defp tile(%{type: :yellow} = assigns) do
    ~H"""
    <.tile_filled class="fill-yellow-400" />
    """
  end

  defp tile(%{type: :purple} = assigns) do
    ~H"""
    <.tile_filled class="fill-purple-400" />
    """
  end

  defp tile(%{type: :orange} = assigns) do
    ~H"""
    <.tile_filled class="fill-orange-400" />
    """
  end

  defp tile(%{type: :drop_preview} = assigns) do
    ~H"""
    <.tile_edged class="fill-slate-500 stroke-0" fill-opacity="0.15" />
    """
  end

  defp tile(%{type: :blocking} = assigns) do
    ~H"""
    <.tile_edged class="fill-slate-700 stroke-slate-800" />
    """
  end

  defp tile(%{type: nil} = assigns) do
    ~H"""
    <.tile_filled class="fill-transparent" />
    """
  end

  attr(:class, :string, default: nil)
  attr(:rest, :global)

  @doc """
  A square SVG that is slightly overlapping the viewBox on all sides to give a filled box
  """
  defp tile_filled(assigns) do
    ~H"""
    <svg class={["h-full w-full stroke-none", @class]} viewBox="0 0 100 100" {@rest}>
      <path d="M -10 -10 H 120 V 120 H -120 V -120" />
    </svg>
    """
  end

  attr(:class, :string, default: nil)
  attr(:rest, :global)

  @doc """
  A square SVG that is slightly within the viewBox to give a border stroke
  """
  defp tile_edged(assigns) do
    ~H"""
    <svg class={["h-full w-full stroke-2", @class]} viewBox="0 0 100 100" {@rest}>
      <path d="M 2 2 H 96 V 96 H -96 V -96" />
    </svg>
    """
  end
end
