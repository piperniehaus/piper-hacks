module Types exposing (..)

import Html exposing (..)
import Http exposing (..)


type alias Me =
    { name : String, id : Int, projects : List Project }


type alias Project =
    { project_name : String, project_id : Int }


type alias Stories =
    List Story


type alias Story =
    { name : String, id : Int, project_id : Int }


type alias Comment =
    { text : String }


type Msg
    = GenerateValues (List ( String, Maybe Msg ))
    | NewItems (List (Html Msg))
    | FetchMeRequest
    | FetchMeResponse (Result Error Me)
    | Clear
    | UpdateToken String
    | ValidateToken
    | FetchStoriesRequest Int
    | FetchStoriesResponse (Result Error Stories)
    | FetchCommentsRequest Int Int
    | FetchCommentsResponse (Result Error (List Comment))
