module StringUtils
    ( toByteString
    ) where

import Data.ByteString.Char8 as C
import Data.Word (Word8)

toByteString :: String -> ByteString
toByteString value =
  C.pack value