module UserCredential
    (UserCredential (..),
    database
    ) where

import Data.ByteString.Char8 as C

data UserCredential = UserCredential { username :: ByteString
                             , hashedPassword :: ByteString
                             } deriving (Show, Eq)

database :: [UserCredential]
database = [UserCredential (C.pack "user1") (C.pack "pwd1")
           , UserCredential (C.pack "user2") (C.pack "pwd2")
           ]