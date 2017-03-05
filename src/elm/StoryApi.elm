module StoryApi exposing (..)

import Http exposing (..)
import Json.Decode as Decode
import Json.Decode.Extra as Decode exposing ((|:))
import Types exposing (..)


fetchCommentsCmd : String -> Int -> Int -> Request (List Comment)
fetchCommentsCmd csrfToken projectId storyId =
    request
        { method = "GET"
        , headers =
            [ Http.header "Content-Type" "application/json"
            , Http.header "X-TrackerToken" csrfToken
            ]
        , url = "https://www.pivotaltracker.com/services/v5/projects/" ++ toString projectId ++ "/stories/" ++ toString storyId ++ "/comments"
        , body = emptyBody
        , expect = expectJson commentsDecoder
        , timeout = Nothing
        , withCredentials = False
        }


commentsDecoder : Decode.Decoder (List Comment)
commentsDecoder =
    Decode.list commentDecoder


commentDecoder : Decode.Decoder Comment
commentDecoder =
    Decode.succeed Comment
        |: Decode.field "text" Decode.string
