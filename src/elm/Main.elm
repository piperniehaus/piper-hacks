module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Task
import Types exposing (..)
import MeApi exposing (..)
import ProjectApi exposing (..)
import StoryApi exposing (..)
import Http exposing (..)
import ItemMaker exposing (..)
import ProjectsCollection exposing (..)
import MaybeHelper as Maybe


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
    , projectsColletion : ProjectsCollection
    , tokenValid : Bool
    , me : Maybe Me
    }


init : ( Model, Cmd msg )
init =
    ( { projectId = 0
      , token = ""
      , items = []
      , projectsColletion = ProjectsCollection []
      , tokenValid = False
      , me = Nothing
      }
    , Cmd.none
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GenerateValues strings ->
            -- ( model, Cmd.none )
            ( model, Random.generate (NewItems << toRandomItems strings) (randomStyleListGenerator <| List.length strings) )

        NewItems div ->
            ( { model | items = List.append model.items div }, Cmd.none )

        FetchMeRequest ->
            ( model, Http.send (FetchMeResponse) <| fetchMeCmd model.token )

        FetchMeResponse result ->
            case result of
                Ok me ->
                    ( { model | tokenValid = True, me = Just me }, Cmd.none )

                Err string ->
                    let
                        foo =
                            (Debug.log "Error" string)
                    in
                        ( model, Cmd.none )

        FetchStoriesRequest id ->
            ( model, Http.send (FetchStoriesResponse) <| fetchStoriesCmd model.token id )

        FetchStoriesResponse result ->
            case result of
                Ok stories ->
                    ( model, message <| GenerateValues <| List.map (\s -> ( s.name, Just (FetchCommentsRequest s.project_id s.id) )) stories )

                Err string ->
                    let
                        foo =
                            (Debug.log "Error" string)
                    in
                        ( model, Cmd.none )

        FetchCommentsRequest projectId storyId ->
            ( model, Http.send (FetchCommentsResponse) <| fetchCommentsCmd model.token projectId storyId )

        FetchCommentsResponse result ->
            case result of
                Ok comments ->
                    ( model, message <| GenerateValues <| List.map (\s -> ( s.text, Nothing )) comments )

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

        ValidateToken ->
            ( model, message FetchMeRequest )



-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib


view : Model -> Html Msg
view model =
    if not model.tokenValid then
        div []
            [ div [ style [ ( "fontFamily", "Helvetica" ), ( "fontSize", "50px" ) ] ] [ text "Please input your Tracker Token" ]
            , Html.form [ onSubmit ValidateToken ]
                [ input
                    [ onInput UpdateToken
                    , placeholder "Tracker token"
                    ]
                    []
                , button [ type_ "submit" ] [ text "Go!" ]
                ]
            ]
    else
        div [ style [ ( "height", "1000px" ), ( "width", "1000px" ), ( "overflow", "hidden" ) ] ] <|
            List.concat
                [ [ button [ onClick (GenerateValues [ ( "hahahah", Nothing ) ]) ] [ text "Make random text" ]
                  , button [ onClick <| GenerateValues (Maybe.mapWithDefault [] (\m -> [ ( m.name, Nothing ) ]) model.me) ] [ text "Me" ]
                  , button [ onClick Clear ] [ text "Clear" ]
                  ]
                , myProjectsButtons model.me
                , model.items
                ]


myProjectsButtons : Maybe Me -> List (Html Msg)
myProjectsButtons maybeMe =
    let
        projects =
            Maybe.mapWithDefault [] .projects maybeMe
    in
        List.map
            (\p ->
                button
                    [ onClick <| GenerateValues [ ( p.project_name, (Just <| FetchStoriesRequest p.project_id) ) ]
                    ]
                    [ text <| p.project_name ]
            )
            projects


message : msg -> Cmd msg
message x =
    Task.perform identity (Task.succeed x)
