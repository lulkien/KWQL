import QtQuick 2.15

Rectangle {
    id: root
    property string label: "value"

    width: ITEM_WIDTH
    height: ITEM_HEIGHT
    color: "#d35d6e"

    Text {
        anchors.centerIn: parent
        text: root.label
        color: "#2a2a2a"
        font.pixelSize: 30
    }
}
