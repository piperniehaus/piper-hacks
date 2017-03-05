module ProjectApi exposing (..)

import Http exposing (..)
import Json.Decode as Decode
import Json.Decode.Extra as Decode exposing ((|:))
import Types exposing (..)


fetchStoriesCmd : String -> Int -> Request Stories
fetchStoriesCmd csrfToken id =
    request
        { method = "GET"
        , headers =
            [ Http.header "Content-Type" "application/json"
            , Http.header "X-TrackerToken" csrfToken
            ]
        , url = "https://www.pivotaltracker.com/services/v5/projects/" ++ toString (Debug.log "id" id) ++ "/stories?limit=10"
        , body = emptyBody
        , expect = expectJson storiesDecoder
        , timeout = Nothing
        , withCredentials = False
        }


storiesDecoder : Decode.Decoder Stories
storiesDecoder =
    Decode.list storyDecoder


storyDecoder : Decode.Decoder Story
storyDecoder =
    Decode.succeed Story
        |: Decode.field "name" Decode.string
        |: Decode.field "id" Decode.int
        |: Decode.field "project_id" Decode.int
