{-# LANGUAGE OverloadedStrings #-}

import Test.HUnit
import Authentication (areCredentialValid,
                       checkCredentialWithDatabase,
                       convertCredentialToUserCredential,
                       parseAuthorizationHeader)
import Test.HUnit
import Data.Monoid
import UserCredential
import Data.ByteString.Char8 as C


testUser :: UserCredential
testUser = UserCredential "user1" "pwd1"

validUserSearchTest :: Assertion
validUserSearchTest = assertEqual "validUserTest"
                                                 True
                                                (checkCredentialWithDatabase (Just testUser) database)


unknownUser :: UserCredential
unknownUser = UserCredential "user3" "pwd3"

invalidUserSearchTest :: Assertion
invalidUserSearchTest = assertEqual "invalidUserTest"
                                                 False
                                                (checkCredentialWithDatabase (Just unknownUser) database)


byteStringCredential :: ByteString
byteStringCredential = "user1:pwd1"

convertCredentialToUserCredentialTest :: Assertion
convertCredentialToUserCredentialTest = assertEqual "convertCredentialToUserCredential"
                                                (Just testUser)
                                                (convertCredentialToUserCredential byteStringCredential)


authorizationHeaderValue :: ByteString
authorizationHeaderValue = "Basic dXNlcjE6cHdkMQ=="

parseAuthorizationHeaderTest :: Assertion
parseAuthorizationHeaderTest = assertEqual "parseAuthorizationHeader"
                                                (Just testUser)
                                                (parseAuthorizationHeader authorizationHeaderValue)

testWithValidHeader :: Assertion
testWithValidHeader = assertEqual "areCredentialValid"
                                                True
                                                (areCredentialValid (Just authorizationHeaderValue) database)

invalidHeader :: ByteString
invalidHeader = "Basic dXNlcdsadjE6cHdkMQ=="

testWithInvalidHeader :: Assertion
testWithInvalidHeader = assertEqual "areCredentialValid"
                                                False
                                                (areCredentialValid (Just invalidHeader) database)


main :: IO ()
main = do
    validUserSearchTest
    invalidUserSearchTest
    convertCredentialToUserCredentialTest
    parseAuthorizationHeaderTest
    testWithValidHeader
    testWithInvalidHeader
