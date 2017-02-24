module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random


-- component import example
-- APP


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = (\_ -> Sub.none)
        , view = view
        }



-- MODEL


type alias Model =
    { projectId : Int
    , items : List (Html Msg)
    }


init : ( Model, Cmd msg )
init =
    ( { projectId = 2
      , items = []
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = GenerateValues String
    | NewItem (Html Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GenerateValues string ->
            -- ( model, Cmd.none )
            ( model, Random.generate (\randList -> NewItem (randomItem string randList)) randomListGenerator )

        NewItem div ->
            ( { model | items = List.append model.items [ div ] }, Cmd.none )



-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib


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


randomItem : String -> List Int -> Html Msg
randomItem string intList =
    div [ style <| randomStyle intList ] [ text string ]


view : Model -> Html Msg
view model =
    div [ style [ ( "height", "100%" ), ( "width", "100%" ) ] ] <|
        List.append
            [ button [ onClick (GenerateValues "hahahah") ] []
            ]
            model.items
