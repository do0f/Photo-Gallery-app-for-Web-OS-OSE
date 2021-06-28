import QtQuick 2.9
import QtQuick.Window 2.2
import QtQml.Models 2.2
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.2

//Main window, maximum resolution
Window {
    id: mainWindow
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true
    title: qsTr("PhotoGallery")

    Rectangle {
        id: root
        property bool fullscreenMode: false //variable to track down viewing mode
        property real currentIndex: 0 //variable to track down current photo for changing views
        width: mainWindow.width
        height: mainWindow.height
        color: "black" //background

        //Folder from which images are taken, set by user, default location is program directory
        FolderListModel {
            id: folderModel
            nameFilters: ["*.png", "*.jpg", "*.jpeg"]
            folder: _picturesFolder //directory path, is passed from c++ code
        }
        //DelegateModel is needed to use on folder model for two views
        DelegateModel {
            id: visualModel
            delegate: PhotoDelegate {}
            model: folderModel
        }

        //Grid View as a first viewing mode (default)
        GridView {
            id: photosGridView
            anchors.fill: parent

            cellWidth: 150 //one image size
            cellHeight: 150

            //Is needed for proper grid position
            property real maxWidth: Math.floor(root.width / cellWidth) * cellWidth
            anchors.leftMargin: (root.width - maxWidth)/2

            interactive: true
            visible: true
            focus: true

            model: visualModel.parts.grid
        }
        //Second viewing mode with one photo on screen
        ListView {
            id: photosListView
            anchors.fill: parent
            orientation: ListView.Horizontal
            snapMode: ListView.SnapOneItem

            interactive: false
            visible: false
            focus: false
            highlightMoveDuration: 0 //no moving animation

            model: visualModel.parts.list
        }

        state: fullscreenMode ?'inList':'inGrid'
        states: [
            State {
                name: 'inList'
                PropertyChanges { //change active view
                    target: photosGridView
                    interactive: false
                    visible: false
                    focus: false
                }
                PropertyChanges {
                    target: photosListView
                    interactive: true
                    visible: true
                    focus: true
                }
            },
            State {
                name: 'inGrid'
                PropertyChanges {
                    target: photosListView
                    interactive: false
                    visible: false
                    focus: false
                }
                PropertyChanges {
                    target: photosGridView
                    interactive: true
                    visible: true
                    focus: true
                }
            }
        ]
        onStateChanged: { //change current index to show proper photo in new view
            if (fullscreenMode)   {
                photosListView.currentIndex = currentIndex
                photosListView.positionViewAtIndex(currentIndex, ListView.Center)
            }
            else {
                photosGridView.currentIndex = currentIndex
                photosGridView.positionViewAtIndex(currentIndex, GridView.Center)
            }
        }

    }
}
