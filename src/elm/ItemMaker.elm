module ItemMaker exposing (..)

import Random
import Html exposing (..)
import Html.Attributes exposing (..)
import Color exposing (Color)
import Html.Events exposing (..)
import Types exposing (..)


type alias RandomStyle =
    { fontSize : Int
    , height : Int
    , marginLeft : Int
    , marginTop : Int
    , color : Color
    }


randomStyleGenerator : Random.Generator RandomStyle
randomStyleGenerator =
    Random.map5 (RandomStyle) (Random.int 0 400) (Random.int 0 400) (Random.int 0 200) (Random.int 0 200) randomColorGenerator


randomStyleListGenerator : Int -> Random.Generator (List RandomStyle)
randomStyleListGenerator num =
    Random.list num randomStyleGenerator



-- randomStyle : Int -> Int -> Int -> Int -> List ( String, String )


colorString : Color -> String
colorString color =
    let
        { red, green, blue, alpha } =
            Color.toRgb color

        colorList =
            [ toString red, toString green, toString blue, toString alpha ]
    in
        "rgba("
            ++ (String.concat <|
                    List.intersperse "," <|
                        colorList
               )
            ++ ")"


randomStyleCss : RandomStyle -> List ( String, String )
randomStyleCss { fontSize, height, marginLeft, marginTop, color } =
    let
        randPixel int =
            (toString int) ++ "px"

        pixelAttributes =
            [ "fontSize", "height", "margin-left", "margin-top" ]
    in
        [ ( "color", Debug.log "color" <| colorString color )
        , ( "position", "absolute" )
        , ( "fontSize", randPixel fontSize )
        , ( "height", randPixel height )
        , ( "marginLeft", randPixel marginLeft )
        , ( "marginTop", randPixel marginTop )
        ]


randomItem : ( String, Maybe Msg ) -> RandomStyle -> Html Msg
randomItem ( string, myMsg ) randomStyle =
    case myMsg of
        Just msg ->
            div [ style <| List.append [ ( "cursor", "pointer" ) ] <| randomStyleCss randomStyle, onClick msg ] [ text string ]

        Nothing ->
            div [ style <| randomStyleCss randomStyle ] [ text string ]


toRandomItems : List ( String, Maybe Msg ) -> List RandomStyle -> List (Html Msg)
toRandomItems stringList randomList =
    List.map2 randomItem stringList randomList


randomColorGenerator : Random.Generator Color.Color
randomColorGenerator =
    Random.map3 Color.rgb (Random.int 0 255) (Random.int 0 255) (Random.int 0 255)
