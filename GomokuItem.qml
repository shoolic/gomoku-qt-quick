import QtQuick 2.0

Rectangle {
    id: gomokuItem

    radius: 16
    width: 2*radius
    height: 2*radius

    color: "#c4c4c4"
    border.color: "black"
    border.width: 1

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked:
            (gomokuItem.state === "" && !board.finished)
            ? (board.blackTurn) ? gomokuItem.state = "BLACK" : gomokuItem.state = "WHITE"
        : null;
    }

    function translateTo1D(x, y) {
        return y*board.columns + x;
    }

    function translateTo2D(index) {
        return { x: index % board.columns, y: parseInt(index / board.columns)}
    }

    function inBoard(x, y) {
        return x >= 0 && y >= 0 && x < board.columns && y < board.rows;
    }

    function checkWin() {
        const dirs = [
        [[ 0, -1], [  0, 1]],
        [[-1,  0], [  1, 0]],
        [[-1, -1], [  1, 1]],
        [[ 1, -1], [ -1, 1]],
        ];

        for (let i = 0; i < 4; i++) {
            const dir = dirs[i]
            let count = 1;
            let startX = -1;
            let startY = -1;

            for (let j = 0; j < 2; j++) {
                const dirTurn = dir[j];
                let {y, x}= translateTo2D(index);
                    while(inBoard(x+dirTurn[0], y+dirTurn[1])
                    && boardRepeater.itemAt(translateTo1D(x+dirTurn[0], y+dirTurn[1])).state
                    === gomokuItem.state) {
                        x+=dirTurn[0];
                        y+=dirTurn[1];
                        count++;
                    }
                    startX = x;
                    startY = y;
            }

            if(count === 5) {
                while(count !== 0) {
                    boardRepeater.itemAt(translateTo1D(startX, startY)).state = "WIN";
                    startX += dir[0][0];
                    startY += dir[0][1];
                    count--;
                }
                board.finished = true;
                return true;
            }
        }

        board.blackTurn = !board.blackTurn;
        return false;
    }

    states: [

        State {
            name: "WHITE"
            PropertyChanges {
                target: gomokuItem; color: "white" }
            StateChangeScript {
                script: checkWin()
            }
        },
        State {
            name: "BLACK"
            PropertyChanges {
                target: gomokuItem; color: "black" }
            StateChangeScript {
                script: checkWin()
            }

        },
        State {
            name: "WIN"
            PropertyChanges {
                target: gomokuItem;
                color: "red"
            }
            StateChangeScript {
                script: checkWin()
            }
        }
    ]

    transitions: [
        Transition { ScriptAction {} }
    ]

    Behavior on state {
        ParallelAnimation {
            ColorAnimation {
                target: gomokuItem;
                duration: 500
            }

            SequentialAnimation {
                ScriptAction {
                    script: gomokuItem.z = 10000
                }

                NumberAnimation {
                    target: gomokuItem
                    property: "scale"
                    duration: 200
                    to: 2
                }

                NumberAnimation {
                    target: gomokuItem
                    property: "scale"
                    duration: 200
                    to: 1
                }

                ScriptAction {
                    script: gomokuItem.z = 0
                }
            }
        }
    }
}

