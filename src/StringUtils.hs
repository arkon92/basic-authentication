module StringUtils
    ( toByteString
    ) where

import Data.ByteString.Char8 as C

toByteString :: String -> ByteString
toByteString value =
  C.pack value