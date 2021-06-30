// Copyright (c) 2020 LG Electronics, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.4
import WebOSServices 1.0
import Eos.Window 0.1
import PmLog 1.0

import QtQuick.Window 2.2
import QtQml.Models 2.2
import Qt.labs.folderlistmodel 2.2

WebOSWindow {
    id: mainWindow
    width: 1920
    height: 1080
    visible: true
    appId: "com.photo.app.qml"
    title: "Photo Gallery"
    displayAffinity: params["displayAffinity"]

    Rectangle {
        id: root
        property bool fullscreenMode: false //variable to track down viewing mode
        property real currentIndex: 0 //variable to track down current photo for changing views
        width: mainWindow.width
        height: mainWindow.height
        color: "black" //background

       //Folder from which images are taken, set by user, default location is standart picture path
        FolderListModel {
            id: folderModel
            nameFilters: ["*.png", "*.jpg", "*.jpeg"]
            showDirs: false
            //folder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0] //directory path
            folder: "Photos"
        }

        //DelegateModel is eeded to use on folder model for two views
        DelegateModel {
            id: visualModel
            delegate: PhotoDelegate{}
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
