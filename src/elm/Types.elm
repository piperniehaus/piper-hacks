module Types exposing (..)


type alias Me =
    { name : String, id : Int, projects : List Project }


type alias Project =
    { project_name : String }


type alias Stories =
    List Story


type alias Story =
    { name : String }
