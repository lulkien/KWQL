import QtQuick 2.15

Item {
    id: root

    width: WINDOW_WIDTH
    height: ITEM_HEIGHT
    clip: true

    signal requestLayouting()

    QtObject {
        id: self
        readonly property double xViewStart: (WINDOW_WIDTH - ITEM_WIDTH - ITEM_SPACING) / 2
        readonly property double xViewEnd: xViewStart + ITEM_WIDTH + ITEM_SPACING
        function cancelAutoLayout() {
            layout_animation.stop()
        }

        function autoLayout() {
            layout_animation.from = layout.xLayoutOffset
            layout_animation.to = xViewStart - layout.highlightItem * (ITEM_WIDTH + ITEM_SPACING) + ITEM_SPACING / 2
            layout_animation.start()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#fafafa"
        opacity: 0.2
    }

    Repeater {
        id: layout
        property double xLayoutOffset: 0
        property int highlightItem: 0
        model: 10
        delegate: MyItem {
            x: layout.xLayoutOffset + index * (ITEM_WIDTH + ITEM_SPACING)
            y: 0
            label: index
        }

        onXLayoutOffsetChanged: {
            updateHighlightItem()
        }

        onHighlightItemChanged: {
            if (highlightItem < 0) {
                highlightItem = 0
            } else if (highlightItem > layout.count - 1) {
                highlightItem = layout.count - 1
            } else {
//                console.warn(highlightItem)
            }
        }

        Component.onCompleted: {
            updateHighlightItem()
            self.autoLayout()
        }

        function updateHighlightItem() {
            // this is the magic of mathematic, lmao
            var _start = (-xLayoutOffset + self.xViewStart + ITEM_SPACING / 2) / (ITEM_WIDTH + ITEM_SPACING)
            highlightItem = Math.min(Math.max(Math.floor(_start), Math.round(_start)), Math.ceil(_start))
        }
    }

    PropertyAnimation {
        id: layout_animation
        target: layout
        property: "xLayoutOffset"
        from: 0
        to: 0
        duration: 250
        alwaysRunToEnd: false
        easing.type: Easing.OutBack
    }

    MouseArea {
        anchors.fill: parent
        drag.target: layout
        property double initLayoutOffset: 0
        property double initMouseX: 0
        property double deltaX: 0
        property double startTime: 0

        property bool interact: false

        onPressed: {
            self.cancelAutoLayout()
            initLayoutOffset = layout.xLayoutOffset
            initMouseX = mouseX
            startTime = Date.now()
            interact = true
        }
        onPositionChanged: {
            if (!interact)
                return
            deltaX = (mouseX - initMouseX)
            layout.xLayoutOffset = initLayoutOffset + deltaX
        }
        onReleased: {
            interact = false
            var deltaTime = (Date.now() - startTime) / 1000
            console.warn("Velocity = ", (deltaX / deltaTime), "px/s")

            initLayoutOffset = 0
            initMouseX = 0
            deltaX = 0
            startTime = 0

            // start auto layout
            self.autoLayout()
        }
    }

    Component.onCompleted: {
    }

}
