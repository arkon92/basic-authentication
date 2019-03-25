import Test.HUnit


import Authentication (areCredentialValid,
                       checkCredentialWithDatabase,
                       convertCredentialToUserCredential,
                       parseAuthorizationHeader)
import Test.HUnit
import Data.ByteString
import Data.Monoid
import StringUtils
import UserCredential


testUser :: UserCredential
testUser = UserCredential (toByteString "user1") (toByteString "pwd1")

validUserSearchTest :: Assertion
validUserSearchTest = assertEqual "validUserTest"
                                                 True
                                                (checkCredentialWithDatabase (Just testUser) database)


unknownUser :: UserCredential
unknownUser = UserCredential (toByteString "user3") (toByteString "pwd3")

invalidUserSearchTest :: Assertion
invalidUserSearchTest = assertEqual "invalidUserTest"
                                                 False
                                                (checkCredentialWithDatabase (Just unknownUser) database)


byteStringCredential :: ByteString
byteStringCredential = toByteString "user1:pwd1"

convertCredentialToUserCredentialTest :: Assertion
convertCredentialToUserCredentialTest = assertEqual "convertCredentialToUserCredential"
                                                (Just testUser)
                                                (convertCredentialToUserCredential byteStringCredential)


authorizationHeaderValue :: ByteString
authorizationHeaderValue = toByteString "Basic dXNlcjE6cHdkMQ=="

parseAuthorizationHeaderTest :: Assertion
parseAuthorizationHeaderTest = assertEqual "parseAuthorizationHeader"
                                                (Just testUser)
                                                (parseAuthorizationHeader authorizationHeaderValue)

testWithValidHeader :: Assertion
testWithValidHeader = assertEqual "areCredentialValid"
                                                True
                                                (areCredentialValid (Just authorizationHeaderValue) database)

invalidHeader :: ByteString
invalidHeader = toByteString "Basic dXNlcdsadjE6cHdkMQ=="

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