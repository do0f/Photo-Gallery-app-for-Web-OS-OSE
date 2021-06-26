import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import Qt.labs.folderlistmodel 2.2
import QtQuick.Controls 2.2

//Main window, maximum resolution
ApplicationWindow {
    id:mainWindow
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true
    title: qsTr("PhotoGallery")

    //Grid View as a first viewing mode
    GridView {
        id:grid
        width: mainWindow.width;
        height: mainWindow.height
        cellWidth: 150
        cellHeight: 150
        focus:true

        readonly property real margin: 10

        //Folder from which images are taken, set by user, default location is program directory
        FolderListModel {
            id: folderModel
            nameFilters: ["*.png", "*.jpg", "*.jpeg"]
            folder: _picturesFolder
        }

        //Component in grid view contains image, rectagle to highlight current element and mouse area for choosing photos
        Component {
            id: fileDelegate
            Item {
                width: grid.cellWidth
                height: grid.cellHeight
                Image {
                    width: parent.width - grid.margin
                    height: parent.height - grid.margin
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    source: folderModel.folder + "/" + fileName
                }
                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "transparent"
                    border.color: index == grid.currentIndex? "black" : "transparent"
                    border.width: grid.margin
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: grid.currentIndex = index
                }
            }
        }


        model: folderModel
        delegate: fileDelegate
    }
}
