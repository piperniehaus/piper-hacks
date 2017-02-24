module ItemMaker exposing (..)

import Random
import Html exposing (..)
import Html.Attributes exposing (..)


randomListGenerator : Random.Generator (List Int)
randomListGenerator =
    Random.list 4 (Random.int 0 400)


randomStyle : List Int -> List ( String, String )
randomStyle intList =
    let
        randPixelValues =
            List.drop 3 intList

        randPixel int =
            (toString int) ++ "px"

        pixelAttributes =
            [ "fontSize", "height", "margin-left", "margin-top" ]
    in
        List.append [ ( "position", "absolute" ), ( "color", "teal" ) ] <|
            List.map2 (\attribute int -> ( attribute, randPixel int ))
                pixelAttributes
                intList


randomItem : String -> List Int -> Html msg
randomItem string intList =
    div [ style <| randomStyle intList ] [ text string ]
