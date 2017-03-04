module ProjectsCollection exposing (..)

import Types exposing (..)


type ProjectsCollection
    = ProjectsCollection (List Project)


projectsList : ProjectsCollection -> List Project
projectsList projectsCollection =
    case projectsCollection of
        ProjectsCollection projectsList ->
            projectsList
