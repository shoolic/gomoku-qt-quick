import QtQuick 2.0

ParallelAnimation {
    id: itemAnimation
    target: itemAnimation
   ColorAnimation { target: target; duration: 500}

   SequentialAnimation {
       ScriptAction {
           script: root.z = 10000
       }

       NumberAnimation {
           target: target
           property: "scale"
           duration: 200
           to: 2
       }
       NumberAnimation {
           target: target
           property: "scale"
           duration: 200
           to: 1
       }
       ScriptAction {
           script: root.z = 0
       }
   }
}
