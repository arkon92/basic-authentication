module Authentication
    ( areCredentialValid
    ) where

import Data.ByteString.Base64 as B
import Data.ByteString.Char8 as C
import Data.List as L
import Debug.Trace as T
import StringUtils
import UserCredential

areCredentialValid :: Maybe ByteString -> Bool
areCredentialValid maybeAuthorizationHeader = case maybeAuthorizationHeader of
                                        Just authorizationHeader ->
                                                                    checkCredentialWithDatabase $
                                                                        parseAuthorizationHeader authorizationHeader
                                        Nothing -> False

parseAuthorizationHeader :: ByteString -> Maybe UserCredential
parseAuthorizationHeader authorizationHeader = do
  let basicWord = toByteString "Basic"
  case (C.words authorizationHeader) of
    basicWord : realm : [] -> readCredential $ B.decodeLenient $ C.tail $ C.dropWhile (/= '=') realm
    _ -> T.trace ("Invalid header format: " ++ (show authorizationHeader)) Nothing

readCredential :: ByteString -> Maybe UserCredential
readCredential credential = do
  let splitCredential = C.span (\x -> x /= ':') credential
  let username = fst splitCredential
  let password = C.tail $ snd splitCredential
  if C.length password == 0
  then Nothing
    else Just UserCredential {username= username, hashedPassword= password}

checkCredentialWithDatabase :: Maybe UserCredential -> Bool
checkCredentialWithDatabase maybeCredential =
  case maybeCredential of
    Just credential -> (L.length $ L.filter (\x -> x == credential) database) > 0
    Nothing -> False