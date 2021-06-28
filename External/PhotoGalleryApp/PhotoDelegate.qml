import QtQuick 2.4

//Package contains two delegates for views
Package {
    Item {
        id: listDelegate
        width: photosListView.width
        height: photosListView.height
        Image {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            fillMode: Image.Pad
            smooth: true
            source: folderModel.folder + "/" + fileName
        }
        MouseArea { //mouse click closes image and changes view
            anchors.fill: parent
            onClicked: {
                root.currentIndex = index;
                root.fullscreenMode = !root.fullscreenMode;
            }
        }
        Package.name: 'list'
    }

    Item {
        id: gridDelegate
        readonly property real margin: 5 //needed for spacing between images in grid
        width: photosGridView.cellWidth
        height: photosGridView.cellHeight
        Image {
            width: parent.width - gridDelegate.margin
            height: parent.height - gridDelegate.margin
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectCrop
            smooth: true
            source: folderModel.folder + "/" + fileName
        }
        Rectangle { //Rectangle is highlighting current photo
            width: parent.width
            height: parent.height
            color: "transparent"
            border.color: index == photosGridView.currentIndex? "white" : "transparent"
            border.width: gridDelegate.margin
        }
        MouseArea { //mouse click opens image in fullscreen
            anchors.fill: parent
            onClicked: {
                photosGridView.currentIndex = index
                root.currentIndex = index;
                root.fullscreenMode = !root.fullscreenMode;
            }
        }
        Package.name: 'grid'
    }

}
