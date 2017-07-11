//***************************************************************************************
//
//  start.qml - QML definition file
//
//***************************************************************************************

import QtQuick 2.6
import QtQuick.Controls 1.4

Item {
//    Component.onCompleted: startBtn.clicked()

    Button {
        id: startBtn
        anchors.centerIn: parent
        text: qsTr("Start Test")
        onClicked: loader.source = "qrc:/test.qml"
        focus: true
        Keys.onSpacePressed: clicked()
    }
}
