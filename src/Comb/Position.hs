module Comb.Position
  ( Position (..)
  , positionBegin
  , WithPosition (..)
  , UpdatePosition (..)
  ) where

-- | A position in a file.
data Position =
  Position
    { line   :: Int
      -- ^ The line.
    , column :: Int
      -- ^ The column.
    , file   :: Maybe String
      -- ^ The file. This can be 'Nothing', when no file is read.
    } deriving (Show, Eq)

-- | The beginning position in a file with no name. Initially, 'line' is @1@ and
-- 'column' is @1@.
positionBegin :: Position
positionBegin = Position { line = 1, column = 1, file = Nothing }

-- | 'WithPosition' @s@ contains a stream @s@ and a position. For a 'Stream' @s@
-- @t@ instance, @t@ should have an instance of 'UpdatePosition'.
data WithPosition s =
  WithPosition
    { position :: Position
    , stream   :: s
    } deriving (Show)

-- | 'UpdatePosition' @t@ is a symbol type @t@ which determines the position in
-- a file. With 'Char', for example, the position is influenced by the number of
-- characters, together with special characters like @'\n'@ and @'\r'@.
class UpdatePosition t where
  -- | 'updatePosition' @t@ @pos@ returns the position in the stream that is
  -- reached by reading @t@ from the stream.
  updatePosition :: t -> Position -> Position

instance UpdatePosition Char where
    updatePosition c pos@Position { line, column } =
      case c of
        '\n' -> pos { line = line + 1, column = 0 }
        '\r' -> pos { column = 0 }
        _    -> pos { column = column + 1 }