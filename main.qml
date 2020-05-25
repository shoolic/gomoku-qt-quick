import QtQuick 2.8
import QtQuick.Window 2.8
import QtQuick.Controls 2.8

Window {
    visible: true
    width: 800
    height: 800
    title: "Gomoku"
    color: "#c4c4c4"

    Column {
        anchors.centerIn: parent
        scale: Math.min(parent.width/width, parent.height/height)
        padding: 10

        InfoLabel {
            id: infoLabel
        }

        Item {
            id: board
            width: columns*40
            height: rows*40
            anchors.horizontalCenter: parent.horizontalCenter

            property int rows: 15
            property int columns: 15

            property bool blackTurn: true
            property bool finished: false

            property var model: Array(rows).fill(Array(columns));

            state: "BLACK_TURN"
            states: [
                State {
                    name: "BLACK_TURN"
                    when: board.blackTurn && !board.finished
                    PropertyChanges {target: infoLabel; text: "Black's turn!" }
                },
                State {
                    name: "WHITE_TURN"
                    when: !board.blackTurn && !board.finished
                    PropertyChanges { target: infoLabel; text: "White's turn!" }
                },
                State {
                    name: "BLACK_WON"
                    when: board.blackTurn && board.finished

                    PropertyChanges { target: infoLabel; text: "Black won!" }
                },
                State {
                    name: "WHITE_WON"
                    when: !board.blackTurn && board.finished
                    PropertyChanges { target: infoLabel; text: "White won!" }
                }
            ]

            signal reset()

            onReset: {
                board.model = Array(board.rows).fill(Array(board.columns))
                boardRepeater.model = null
                boardRepeater.model = [].concat(...board.model)
                board.blackTurn = true
                board.finished = false
            }

            Grid {
                id: boardGrid
                anchors.horizontalCenter: parent.horizontalCenter
                columns: board.columns
                rows: board.rows
                spacing: 5
                Repeater {
                    id: boardRepeater
                    model:  [].concat(...board.model)
                    GomokuItem {}


                    Behavior on model {
                        SequentialAnimation {

                            NumberAnimation {
                                target: boardGrid
                                property: "scale"
                                duration: 200
                                to: 0
                            }
                            NumberAnimation {
                                target: boardGrid
                                property: "scale"
                                duration: 200
                                to: 1
                            }
                        }
                    }
                }
            }
        }

        Button {
            text: "Reset"
            highlighted: true
            anchors.horizontalCenter: parent.horizontalCenter
            onPressed: board.reset()
        }
    }
}
