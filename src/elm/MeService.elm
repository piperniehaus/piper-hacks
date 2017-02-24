module MeService exposing (..)

import Http exposing (..)
import Json.Decode as Decode
import Json.Decode.Extra as Decode exposing ((|:))
import Types exposing (..)


fetchMeCmd : String -> Request Me
fetchMeCmd csrfToken =
    request
        { method = "GET"
        , headers =
            [ Http.header "Content-Type" "application/json"
            , Http.header "X-TrackerToken" csrfToken
            ]
        , url = "https://www.pivotaltracker.com/services/v5/me?fields=%3Adefault"
        , body = emptyBody
        , expect = expectJson meDecoder
        , timeout = Nothing
        , withCredentials = False
        }


meDecoder : Decode.Decoder Me
meDecoder =
    Decode.succeed Me
        |: Decode.at [ "name" ] Decode.string
        |: Decode.field "id" Decode.int
        |: Decode.at [ "projects" ] projectsDecoder


projectsDecoder : Decode.Decoder (List Project)
projectsDecoder =
    Decode.list
        projectDecoder


projectDecoder : Decode.Decoder Project
projectDecoder =
    Decode.succeed Project
        |: Decode.field "project_name" Decode.string
