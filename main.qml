import QtQuick 2.12
import QtQuick.LocalStorage 2.12
import QtQuick.Layouts 1.12
import QtQml 2.12
import QtQuick.Controls 2.5
import "methods.js" as Utils

ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("TestTask")
    property string currentCurrency: ""

    Component {
        id: listCurrency
        Item {
            ListModel {
                id: listModelCurrency
            }

            ListView {
                id: listViewCurrency
                anchors.fill: parent
                model: listModelCurrency
                delegate: Text {
                    text: name
                    font.pointSize: 20
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            listViewCurrency.currentIndex = index
                        }
                        onDoubleClicked: {
                           currentCurrency = listModelCurrency.get(index).name
                           stackView.push(commentCurrency)
                        }
                    }
                }

                highlight: Rectangle {
                    color: "lightsteelblue"
                    radius: 2
                }
                focus: true

                ScrollBar.vertical: ScrollBar {}

            }

            Button {
                id: buttonLoad
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.bottom: parent.bottom
                anchors.margins: 10
                antialiasing: true

                text: qsTr("Request")

                onClicked: Utils.makeRequest(listModelCurrency)
            }
        }
    }

    Component {
        id: commentCurrency
        Item {
            ColumnLayout {
                spacing: 2
                Label {
                    font.pointSize: 20
                    padding: 5
                    text: "Редактирование валюты " + currentCurrency
                }

                TextEdit {
                    id: comment
                    text: Utils.getComment(currentCurrency)
                    font.pointSize: 20
                    padding: 5
                    property string placeholderText: "Введите комментарий к валюте"

                    Text {
                        font.pointSize: 20
                        text: comment.placeholderText + " " + currentCurrency
                        color: "#aaa"
                        visible: !comment.text
                    }
                }
            }

            Button {
                id: buttonSaveComment
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.bottom: parent.bottom
                anchors.margins: 10
                antialiasing: true

                text: qsTr("Save")

                onClicked: {
                    Utils.saveComment(currentCurrency, comment.text)
                    stackView.pop(null)
                }
            }
        }
    }

    StackView {
        id: stackView
        initialItem: listCurrency
        anchors.fill: parent
    }


    Component.onCompleted: Utils.createDB();
}
