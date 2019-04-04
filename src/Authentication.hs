module Authentication
    ( areCredentialValid,
      convertCredentialToUserCredential,
      checkCredentialWithDatabase,
      parseAuthorizationHeader
    ) where

import Data.ByteString.Base64 as B
import Data.ByteString.Char8 as C
import Data.List as L
import Debug.Trace as T
import UserCredential

areCredentialValid :: Maybe ByteString -> [UserCredential] -> Bool
areCredentialValid maybeAuthorizationHeader registeredUsers = case maybeAuthorizationHeader of
                                        Just authorizationHeader ->
                                                 checkCredentialWithDatabase
                                                            (parseAuthorizationHeader authorizationHeader)
                                                            registeredUsers

                                        Nothing -> False

parseAuthorizationHeader :: ByteString -> Maybe UserCredential
parseAuthorizationHeader authorizationHeader = do
  let basicWord = "Basic"
  case (C.words authorizationHeader) of
    basicWord : credential : [] -> convertCredentialToUserCredential $ B.decodeLenient $ credential
    _ -> T.trace ("Invalid header format: " ++ (show authorizationHeader)) Nothing

convertCredentialToUserCredential :: ByteString -> Maybe UserCredential
convertCredentialToUserCredential credential = do
  let splitCredential = C.span (\x -> x /= ':') credential
  let username = fst splitCredential
  let password = C.tail $ snd splitCredential
  if C.length password == 0
  then Nothing
    else Just UserCredential {username= username, hashedPassword= password}

checkCredentialWithDatabase :: Maybe UserCredential -> [UserCredential] -> Bool
checkCredentialWithDatabase maybeCredential registeredUsers =
  case maybeCredential of
    Just credential -> (L.length $ L.filter (\x -> x == credential) registeredUsers) > 0
    Nothing -> False
