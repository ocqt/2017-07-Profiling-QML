import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    property alias loader: loader

    visible: true
    width: 800
    height: 720
    title: qsTr("Performance Test")

    Loader {
        id: loader
        anchors.fill: parent
        source: "qrc:/start.qml"
    }
}
