module Main exposing (..)

import Char
import Dict exposing (Dict)
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String


type alias Model =
    { inputValue : Maybe String
    }


initialModel : Model
initialModel =
    Model Nothing


charMap : Dict Char String
charMap =
    [97..123]
        |> List.map (\x -> ( Char.fromCode x, toString (x - 96) ))
        |> Dict.fromList


type alias Icon =
    { url : String
    , text : String
    }


type Msg
    = Input String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input val ->
            { model | inputValue = Just val }


getCodeFromValue : String -> String
getCodeFromValue =
    String.toLower
        >> String.toList
        >> List.map mapCharToCode
        >> List.intersperse "-"
        >> String.concat


mapCharToCode : Char -> String
mapCharToCode char =
    case Dict.get char charMap of
        Just value ->
            value

        Nothing ->
            String.fromChar char


headerView : Html msg
headerView =
    div [ class "row" ]
        [ nav
            [ class "top-bar"
            , attribute "data-topbar" "true"
            , attribute "role" "navigation"
            ]
            [ ul [ class "title-area" ]
                [ li [ class "name" ]
                    [ h1 []
                        [ img
                            [ src "http://www.kevindecock.be/apps/supercrypt/img/logo_text_white.png"
                            , alt "supercrypt!"
                            , id "logoimg"
                            ]
                            []
                        ]
                    ]
                ]
            ]
        ]


iconView : Icon -> Html msg
iconView icon =
    div
        [ class "small-12 medium-4 large-4 columns text-center"
        , style [ ( "height", "320px" ) ]
        ]
        [ img
            [ class "smallicon"
            , src icon.url
            ]
            []
        , p []
            [ text icon.text ]
        ]


iconsView : Html msg
iconsView =
    div [ class "row" ]
        (List.map iconView
            [ { url = "http://www.kevindecock.be/apps/supercrypt/img/icons/dots.png"
              , text = "1. Enter a fun message to your kids below."
              }
            , { url = "http://www.kevindecock.be/apps/supercrypt/img/icons/hash_bourgondy.png"
              , text = "2. Magic! It gets encoded with a super secret key."
              }
            , { url = "http://www.kevindecock.be/apps/supercrypt/img/icons/questionmark_orange.png"
              , text = "3. Let your kids guess the code - how fast can they figure out the message?"
              }
            ]
        )


encoderView : Model -> Html Msg
encoderView model =
    div [ class "row" ]
        [ div
            [ class "small-12 medium-5 large-5 columns my-panel with-arrow-left"
            ]
            [ h2 [ class "text-center", style [ ( "color", "white" ) ] ]
                [ text "Just start typing:" ]
            , input
                [ onInput Input
                , placeholder "What would you like to encode?"
                , type' "text"
                ]
                []
            ]
        , case model.inputValue of
            Nothing ->
                text ""

            Just value ->
                div
                    [ class "small-12 medium-6 large-6 columns my-panel dotted"
                    , id "resultID"
                    , style [ ( "height", "inherit" ) ]
                    ]
                    [ h2 [ class "text-center" ]
                        [ text "Here's the result:" ]
                    , p []
                        [ text <| getCodeFromValue value ]
                    ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ headerView
        , div [ class "page page-main" ]
            [ div [ class "view-container" ]
                [ div [ class "row" ]
                    [ div [ class "small-12 medium-12 medium-centered columns" ]
                        [ h1 [ class "text-center" ]
                            [ text "Let's play SuperCrypt#!" ]
                        ]
                    ]
                , iconsView
                , encoderView model
                ]
            ]
        ]


main : Program Never
main =
    App.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }
