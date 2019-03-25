module Main where

import Authentication (areCredentialValid)
import Data.Maybe
import Happstack.Server (Method(GET), dir, getHeaderM, look, method, nullConf, ok, simpleHTTP, ServerPart)
import UserCredential (database)

authorizationHeader :: String
authorizationHeader = "Authorization"

main :: IO ()
main = do
    putStrLn $ "Server started on port " ++ show 8000
    simpleHTTP nullConf $ privatePart

privatePart:: ServerPart String
privatePart = do
  dir "private" $ do method GET
                     maybeAuthorizationHeader <- getHeaderM authorizationHeader
                     let authenticationSuccess = areCredentialValid maybeAuthorizationHeader database
                     if authenticationSuccess
                     then ok $ "Autentication succeed"
                      else ok $ "Invalid credential"

