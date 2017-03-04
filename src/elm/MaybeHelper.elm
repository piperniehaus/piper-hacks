module MaybeHelper exposing (..)


mapWithDefault : b -> (a -> b) -> Maybe a -> b
mapWithDefault default func maybeItem =
    Maybe.withDefault default <| Maybe.map func maybeItem
