import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    width: WINDOW_WIDTH
    height: WINDOW_HEIGHT
    maximumWidth: WINDOW_WIDTH
    minimumWidth: WINDOW_WIDTH
    maximumHeight: WINDOW_HEIGHT
    minimumHeight: WINDOW_HEIGHT
    visible: true
    title: qsTr("qt-bypass-tiling Test")

    Rectangle {
        anchors.fill: parent
        color: "#2a2a2a"
    }

//    Rectangle {
//        anchors.centerIn: parent
//        height: WINDOW_HEIGHT
//        width: ITEM_WIDTH + ITEM_SPACING
//        color: "#123789"
//    }

    KWQList {
        anchors.centerIn: parent
    }
}
