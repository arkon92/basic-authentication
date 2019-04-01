# basic-authentication

This is a basic authentication service :

## How to compile ?
    stack build

## How to run ?
    stack exec basic-authentication-exe

    curl -H "Authorization: Basic dXNlcjE6cHdkMQ==" http://localhost:8000/private
