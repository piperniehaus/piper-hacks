module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Task
import Types exposing (..)
import MeService exposing (..)
import Http exposing (..)
import ItemMaker exposing (..)


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
    , token : String
    , items : List (Html Msg)
    }


init : ( Model, Cmd msg )
init =
    ( { projectId = 0
      , token = ""
      , items = []
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = GenerateValues String
    | NewItem (Html Msg)
    | FetchMeRequest
    | FetchMeResponse (Result Error Me)
    | Clear
    | UpdateToken String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GenerateValues string ->
            -- ( model, Cmd.none )
            ( model, Random.generate (\randList -> NewItem (randomItem string randList)) randomListGenerator )

        NewItem div ->
            ( { model | items = List.append model.items [ div ] }, Cmd.none )

        FetchMeRequest ->
            ( model, Http.send (FetchMeResponse) <| fetchMeCmd model.token )

        FetchMeResponse result ->
            case result of
                Ok me ->
                    ( model, message (GenerateValues <| me.name) )

                Err string ->
                    let
                        foo =
                            (Debug.log "Error" string)
                    in
                        ( model, Cmd.none )

        Clear ->
            ( { model | items = [] }, Cmd.none )

        UpdateToken token ->
            ( { model | token = token }, Cmd.none )



-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib


view : Model -> Html Msg
view model =
    div [ style [ ( "height", "100%" ), ( "width", "100%" ) ] ] <|
        List.append
            [ button [ onClick (GenerateValues "hahahah") ] [ text "Make random text" ]
            , button [ onClick FetchMeRequest ] [ text "Me" ]
            , button [ onClick Clear ] [ text "Clear" ]
            , input [ onInput UpdateToken, placeholder "Tracker token" ] []
            ]
            model.items


message : msg -> Cmd msg
message x =
    Task.perform identity (Task.succeed x)
