import QtQuick 2.15

Item {
    id: root

    width: WINDOW_WIDTH
    height: ITEM_HEIGHT
    clip: true
    property alias model: layout.model
    property alias delegate: layout.delegate
    readonly property int highlightItem: self.highlightItem

    QtObject {
        id: self

        // properties
        readonly property double xViewStart: (WINDOW_WIDTH - ITEM_WIDTH - ITEM_SPACING) / 2
        readonly property int layoutDuration: 250
        property double xLayoutOffset: self.xViewStart
        property int highlightItem: 0

        // signal hanlders
        onXLayoutOffsetChanged: {
            updateHighlightItem()
        }

        onHighlightItemChanged: {
            if (highlightItem < 0) {
                highlightItem = 0
            } else if (highlightItem > layout.count - 1) {
                highlightItem = layout.count - 1
            } else {
                // do nothing
                // console.warn("HL =", highlightItem)
            }
        }

        // functions
        function updateHighlightItem() {
            // This is an example of the magic of mathematics, lmao
            var _start = (-self.xLayoutOffset + self.xViewStart + ITEM_SPACING / 2) / (ITEM_WIDTH + ITEM_SPACING)
            self.highlightItem = Math.min(Math.max(Math.floor(_start), Math.round(_start)), Math.ceil(_start))
        }

        function cancelAutoLayout() {
            layout_animation.stop()
        }

        function autoLayout() {
            layout_animation.from = self.xLayoutOffset
            layout_animation.to = xViewStart - self.highlightItem * (ITEM_WIDTH + ITEM_SPACING) + ITEM_SPACING / 2
            layout_animation.start()
        }
    }

//    Rectangle {
//        anchors.fill: parent
//        color: "#fafafa"
//        opacity: 0.2
//    }

    Repeater {
        id: layout
        model: 10
        delegate: MyItem {
            x: self.xLayoutOffset + index * (ITEM_WIDTH + ITEM_SPACING)
            label: index
        }
    }

    PropertyAnimation {
        id: layout_animation
        target: self
        property: "xLayoutOffset"
        from: 0
        to: 0
        duration: self.layoutDuration
        alwaysRunToEnd: false
        easing.type: Easing.OutBack
//        easing.type: Easing.InQuad
    }

    MouseArea {
        id: mouse_control
        anchors.fill: root
        drag.target: layout
        property bool interact: false

        // positioning
        property double initLayoutOffset: 0
        property double initMouseX: 0

        // flick
        property double deltaX: 0
        property double deltaTime: 0        // second
        property double flickVelocity: 0    // pixels per second

        readonly property double flickVelocityEfficiency: 0.005  // tune this value for better animation
        readonly property double flickVelocityLoss: 0.03         // tune this value for better animation

        onPressed: {
            self.cancelAutoLayout()
            initLayoutOffset = self.xLayoutOffset
            initMouseX = mouseX
            deltaTime = Date.now()
            flickVelocity = 0
            interact = true
        }

        onPositionChanged: {
            if (!interact)
                return
            deltaX = (mouseX - initMouseX)
            self.xLayoutOffset = initLayoutOffset + deltaX
        }

        onReleased: {
            interact = false
            // flicking
            deltaTime = (Date.now() - deltaTime) / 1000 // get second from mil second
            flickVelocity = deltaX / deltaTime
            deltaTime = 0
            deltaX = 0
            // positioning
            initLayoutOffset = 0
            initMouseX = 0
            // start auto layout
            flick_animation.start()
        }
    }

    Timer {
        id: flick_animation
        interval: 1
        repeat: true
        onTriggered: {
            // This is another example of the magic of mathematics. xD
            self.xLayoutOffset = self.xLayoutOffset + (mouse_control.flickVelocity * mouse_control.flickVelocityEfficiency)
            mouse_control.flickVelocity = mouse_control.flickVelocity * (1 - mouse_control.flickVelocityLoss)

            // TODO: handle bound value if possible, the velocity will reduce dramatically if over bound
            // if dont have enough time, just keep it
            if (Math.abs(mouse_control.flickVelocity) < (ITEM_WIDTH)) {
                mouse_control.flickVelocity = 0
                flick_animation.stop()
                self.autoLayout()
            }
        }
    }

    Component.onCompleted: {
        self.updateHighlightItem()
        self.autoLayout()
    }
}
