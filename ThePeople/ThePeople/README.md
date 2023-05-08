#  Key points
## Add launch Screen
1. Info.plist > Launch Screen > Background Color, Image Name
2. Add color and image to Assets

## Date format
1982-12-20T00:00:00+00:00
called iso8601 format
after + is time zone offset

## Postman
use postman app to make requests to APIs and see replyes

## Coding Keys
use to align model properties and JSON properties

on JSONEncoder and JSONDecoder use dateDecodingStrategy for dates and keyEncoding strategy for models
If data doesn't exist in JSON, mark model property as optional


## Generics
use generics to write reusable code. Warning: better works on refactroring

## JSON Files
use json files to model network requests before actually networking
StaticJSONMapper -> read file from bundle
