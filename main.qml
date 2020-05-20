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

        InfoLabel {
        id: infoLabel
        }

        Item {
            id: board
            width: columns*40
            height: rows*40
            anchors.horizontalCenter: parent.horizontalCenter

            property int rows: 10
            property int columns: 10

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
                }
            }
        }
    }
}
