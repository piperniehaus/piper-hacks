module ItemMaker exposing (..)

import Random
import Html exposing (..)
import Html.Attributes exposing (..)
import Color exposing (Color)


--
-- randomColorAndIntGenerator :
--     Random.Generator Color
--     -> Random.Generator List Int
--     -> Random.Generator ( Color, List Int )
-- randomColorAndIntGenerator colorGen intListGen =
--     Random.map2 (,) colorGen intListGen
--
--


randomColorGenerator : Random.Generator Color.Color
randomColorGenerator =
    Random.map3 Color.rgb (Random.int 0 255) (Random.int 0 255) (Random.int 0 255)


type alias RandomStyle =
    { fontSize : Int
    , height : Int
    , marginLeft : Int
    , marginTop : Int
    , color : Color
    }


randomStyleGenerator : Random.Generator RandomStyle
randomStyleGenerator =
    Random.map5 (RandomStyle) (Random.int 0 400) (Random.int 0 400) (Random.int 0 400) (Random.int 0 400) randomColorGenerator


randomStyleListGenerator : Int -> Random.Generator (List RandomStyle)
randomStyleListGenerator num =
    Random.list num randomStyleGenerator


randomListGenerator : Random.Generator (List Int)
randomListGenerator =
    Random.list 4 (Random.int 0 400)


randomListsGenerator : Int -> Random.Generator (List (List Int))
randomListsGenerator numLists =
    Random.list numLists randomListGenerator



-- randomStyle : Int -> Int -> Int -> Int -> List ( String, String )


randomStyleCss : RandomStyle -> List ( String, String )
randomStyleCss { fontSize, height, marginLeft, marginTop } =
    let
        randPixel int =
            (toString int) ++ "px"

        pixelAttributes =
            [ "fontSize", "height", "margin-left", "margin-top" ]
    in
        [ ( "position", "absolute" )
        , ( "color", "teal" )
        , ( "fontSize", randPixel fontSize )
        , ( "height", randPixel height )
        , ( "marginLeft", randPixel marginLeft )
        , ( "marginTop", randPixel marginTop )
        ]


randomItem : String -> RandomStyle -> Html msg
randomItem string randomStyle =
    div [ style <| randomStyleCss randomStyle ] [ text string ]


toRandomItems : List String -> List RandomStyle -> List (Html msg)
toRandomItems stringList randomList =
    List.map2 randomItem stringList randomList
