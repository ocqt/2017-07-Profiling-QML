//***************************************************************************************
//
//  test.qml - QML definition file
//
//***************************************************************************************

import QtQuick 2.6
import QtQuick.Controls 1.4

Item {
    id: root

    property real gravity: .01
    property real friction: .999
    property real tooClose: 1
    property var points: []
    property var vectors: []
    property real mass: 20

    function initialize(count) {
        var wMax = canvas.width
        var hMax = canvas.height
        var vMax = 2;

        points = []
        vectors = []

        for (var i = 0; i < count; i++) {
            var x = Math.floor(Math.random() * wMax)
            var y = Math.floor(Math.random() * hMax)
            var vecX = 2*(Math.random() * vMax) - vMax
            var vecY = 2*(Math.random() * vMax) - vMax
            points.push(Qt.point(x, y))
            vectors.push(Qt.point(vecX, vecY))
        }
    }

    // delay calling the callback function by number of milliseconds specified in interval
    // see: https://stackoverflow.com/questions/30754412/qtimersingleshot-equivalent-for-qml
    function delayCall( interval, callback ) {
        var delayCaller = delayCallerComponent.createObject( null, { "interval": interval } );
        delayCaller.triggered.connect( function () {
            callback();
            delayCaller.destroy();
        } );
        delayCaller.start();
    }

    // calculate forces of gravity
    function runGravity() {
        var newPts = []
        var newVecs = []
        for (var i in points) {
            var xForce = 0
            var yForce = 0
            for (var j in points) {
                if (i === j) continue

                var a = points[j].x - points[i].x
                var b = points[j].y - points[i].y
                var d = Math.sqrt(a*a + b*b)

                // ignore collisions
                if (d < tooClose) continue

                var force = gravity*(mass * mass)/Math.pow(d, 2)
                a = a * force
                b = b * force
                xForce += a/5
                yForce += b/5
            }

            newVecs.push(Qt.point(friction*(vectors[i].x + xForce), friction*(vectors[i].y + yForce)))
            newPts.push(Qt.point(points[i].x + newVecs[i].x, points[i].y + newVecs[i].y))
        }
        points = newPts
        vectors = newVecs
    }

    onHeightChanged: moveAnim.reset(height)
    Component.onCompleted: initialize(spinBox.value)

    Rectangle {
        id: ctrlPanel
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
        width: ctrls.width + 20
        color: "teal"

        Rectangle {
            id: bar
            anchors { left: parent.left; right: parent.right }
            height: 2
            color: "yellow"
            clip: true

            SequentialAnimation on y {
                id: moveAnim
                function reset(max) {
                    stop()
                    bar.height = max/60
                    anim1.to = root.height - bar.height
                    anim2.from = anim1.to
                    start()
                }

                loops: Animation.Infinite

                NumberAnimation { id: anim1; easing.type: Easing.InOutSine; duration: 1000 }
                NumberAnimation { id: anim2; easing.type: Easing.InOutSine; duration: 1000; to: 0 }
            }
        }

        Column {
            id: ctrls
            anchors.centerIn: parent
            spacing: 10

            Button {
                text: qsTr("Return to Start")
                onClicked: loader.source = "qrc:/start.qml"
            }
            SpinBox {
                id: spinBox
                maximumValue: 500
                minimumValue: 5
                stepSize: 5
                value: 40
                onValueChanged: initialize(value)
            }
        }
    }

    Canvas {
        id: canvas

        anchors { left: ctrlPanel.right; right: parent.right; top: parent.top; bottom: parent.bottom }
        antialiasing: true
        clip: true

        onPaint: {
            // get context to draw with
            var ctx = getContext("2d")

            ctx.fillStyle = "#000"
            ctx.fillRect(0,0,canvas.width,canvas.height);

            // draw all points
            for (var i in points) {
                context.beginPath();
                context.fillStyle = "white"
                context.strokeStyle = "blue"
                context.moveTo(points[i].x + 3, points[i].y);
                context.arc(points[i].x, points[i].y, 3, 0, 2*Math.PI, true)
                context.fill();
                context.stroke();
            }
        }
        onPainted: {
            runGravity()
            delayCall(1, function() { canvas.requestPaint() })
        }
    }

    Component { id: delayCallerComponent; Timer {} }
}
