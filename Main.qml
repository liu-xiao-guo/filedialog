import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 0.1
import Qt.labs.folderlistmodel 2.1

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "filedialog.ubuntu"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(60)
    height: units.gu(75)

    Page {
        title: i18n.tr("Simple")

        Button {
            id: launcher
            text: i18n.tr("Open")
            width: units.gu(16)
            onClicked: PopupUtils.open(dialog, launcher)
        }

        Component {
            id: dialog
            Dialog {
                id: dialogue

                title: "FileList Dialog"
                text: "Show the files"

                ListView {
                    id: listview
                    width: parent.width
                    height: 200

                    FolderListModel {
                        id: folderModel
                        nameFilters: ["*.qml"]

                    }

                    Component {
                        id: fileDelegate
                        Text {
                            id: text
                            text: fileName
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    console.log("it is clicked");
                                    listview.currentIndex = index;
                                }
                            }
                        }
                    }

                    // Define a highlight with customized movement between items.
                    Component {
                        id: highlightBar
                        Rectangle {
                            width: fileDelegate.width; height: 50
                            color: "red"
                            y: listview.currentItem.y;
                            Behavior on y { SpringAnimation { spring: 2; damping: 0.1 } }
                        }
                    }

                    focus: true
                    model: folderModel
                    delegate: fileDelegate
                    highlight: highlightBar

                }

                Row {
                    id: row
                    width: parent.width
                    spacing: units.gu(1)
                    Button {
                        width: parent.width/2
                        text: "Cancel"
                        onClicked: PopupUtils.close(dialogue)
                    }

                    Button {
                        width: parent.width/2
                        text: "Confirm"
                        color: UbuntuColors.green
                        onClicked: {
                            console.log("caller: " + dialogue.caller);
                            console.log("currentIndex: " + listview.currentIndex);
                            console.log(folderModel.get(listview.currentIndex, "fileName"));
                            launcher.update();
                            PopupUtils.close(dialogue)
                        }
                    }
                }
            }
        }
    }
}

