import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import Qt.labs.folderlistmodel 2.2
import QtQuick.Controls 2.2


ApplicationWindow {
    id:mainWindow
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true
    title: qsTr("PhotoGallery")

    GridView {
        id:grid
        width: mainWindow.width;
        height: mainWindow.height


        FolderListModel {
            id: folderModel
            nameFilters: ["*.png", "*.jpg", "*.jpeg"]
            folder: _picturesFolder
        }

        Component {
            id: fileDelegate
                Image {
                    width: grid.cellWidth; height: grid.cellHeight
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    source: folderModel.folder + "/" + fileName
                }
        }

        model: folderModel
        delegate: fileDelegate
        }
}
