defmodule Tetrex.Board do
  alias Tetrex.SparseGrid
  alias Tetrex.Tetromino

  @type placement_error :: :collision

  @tile_bag_size 9999

  @enforce_keys [
    :playfield,
    :playfield_height,
    :playfield_width,
    :current_tile,
    :next_tile,
    :hold_tile,
    :upcoming_tiles
  ]
  defstruct [
    :playfield,
    :playfield_height,
    :playfield_width,
    :current_tile,
    :next_tile,
    :hold_tile,
    :upcoming_tiles
  ]

  @spec new(non_neg_integer(), non_neg_integer(), integer()) :: __MODULE__.t()
  def new(height, width, random_seed) do
    [current_tile | [next_tile | upcoming_tiles]] =
      Tetromino.draw_randoms(@tile_bag_size, random_seed)

    %__MODULE__{
      playfield: SparseGrid.new(),
      playfield_height: height,
      playfield_width: width,
      current_tile: current_tile,
      next_tile: next_tile,
      hold_tile: nil,
      upcoming_tiles: upcoming_tiles
    }
  end

  @doc """
  Attempt to place the next tile on the board.
  An error is returned if the tile could no be placed due to the board already being full.
  """
  @spec place_next_tile(__MODULE__.t()) :: {:ok, __MODULE__.t()} | {:error, placement_error()}
  def place_next_tile(board) do
    candidate_placement =
      SparseGrid.align(
        Tetromino.tetromino!(board.next_tile),
        {0, 0},
        {board.playfield_height, board.playfield_width},
        :top_centre
      )

    if SparseGrid.overlaps?(candidate_placement, board.playfield) do
      {:error, :collision}
    else
      [next_tile | upcoming_tiles] = board.upcoming_tiles

      {:ok,
       %{
         board
         | current_tile: board.next_tile,
           next_tile: next_tile,
           upcoming_tiles: upcoming_tiles
       }}
    end
  end
end
