import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Extras 1.4

TabView {
    Tab {
        title: qsTr("Basic")

        Column {
            anchors.margins: 0.2 * dpi
            anchors.fill: parent
            spacing: 0.1 * dpi

            Row {
                id: rowGethDatadir
                width: parent.width

                Label {
                    id: gethDDLabel
                    text: "Geth Data Directory: "
                }

                TextField {
                    id: gethDDField
                    width: parent.width - gethDDButton.width - gethDDLabel.width
                    text: settings.value("geth/datadir", "")
                    onTextChanged: {
                        settings.setValue("geth/datadir", gethDDField.text)
                    }
                }

                Button {
                    id: gethDDButton
                    text: qsTr("Choose")

                    onClicked: {
                        ddFileDialog.open()
                    }
                }

                FileDialog {
                    id: ddFileDialog
                    title: qsTr("Geth data directory")
                    selectFolder: true
                    selectExisting: true
                    selectMultiple: false

                    onAccepted: {
                        gethDDField.text = ddFileDialog.fileUrl.toString().replace(/^(file:\/{3})/,""); // fugly but gotta love QML on this one
                    }
                }
            }

            Row {
                width: parent.width

                Label {
                    text: qsTr("Update interval (s): ")
                }

                SpinBox {
                    id: intervalSpinBox
                    width: 1 * dpi
                    minimumValue: 5
                    maximumValue: 60

                    value: settings.value("ipc/interval", 10)
                    onValueChanged: {
                        settings.setValue("ipc/interval", intervalSpinBox.value)
                        ipc.setInterval(intervalSpinBox.value * 1000)
                    }
                }
            }

            ErrorDialog {
                id: hfConfirmDialog
                title: qsTr("Warning")
                msg: qsTr("Changing hard fork decision requires a restart of Etherwall (and geth if running externally).")
            }

            Row {
                width: parent.width

                Label {
                    text: qsTr("Support DAO hard fork: ")
                }

                ToggleButton {
                    id: hfButton

                    checked: settings.valueBool("geth/hardfork", true)
                    text: checked ? qsTr("support") : qsTr("oppose")
                    onClicked: {
                        settings.setValue("geth/hardfork", checked)
                        if ( settings.contains("program/firstrun") ) {
                            hfConfirmDialog.show()
                        }
                    }
                }
            }
        }
    }

    Tab {
        title: qsTr("Advanced")

        Column {
            anchors.margins: 0.2 * dpi
            anchors.fill: parent
            spacing: 0.1 * dpi

            Row {
                id: rowGethPath
                width: parent.width

                Label {
                    id: gethPathLabel
                    text: "Geth path: "
                }

                TextField {
                    id: gethPathField
                    width: parent.width - gethPathLabel.width - gethPathButton.width
                    text: settings.value("geth/path", "")
                    onTextChanged: {
                        settings.setValue("geth/path", gethPathField.text)
                    }
                }

                Button {
                    id: gethPathButton
                    text: qsTr("Choose")

                    onClicked: {
                        gethFileDialog.open()
                    }
                }

                FileDialog {
                    id: gethFileDialog
                    title: qsTr("Geth executable")
                    selectFolder: false
                    selectExisting: true
                    selectMultiple: false

                    onAccepted: {
                        gethPathField.text = gethFileDialog.fileUrl.toString().replace(/^(file:\/{3})/,""); // fugly but gotta love QML on this one
                    }
                }
            }

            // TODO: rename to infodialog
            ErrorDialog {
                id: confirmDialog
                title: qsTr("Warning")
                msg: qsTr("Changing the chain requires a restart of Etherwall (and geth if running externally).")
            }

            Row {
                id: rowGethTestnet
                width: parent.width

                Label {
                    id: gethTestnetLabel
                    text: "Testnet: "
                }

                CheckBox {
                    id: gethTestnetCheck
                    checked: settings.valueBool("geth/testnet", false)
                    onClicked: {
                        settings.setValue("geth/testnet", gethTestnetCheck.checked)
                        if ( settings.contains("program/firstrun") ) {
                            confirmDialog.show()
                        }
                    }
                }
            }

            Row {
                id: rowGethArgs
                width: parent.width

                Label {
                    id: gethArgsLabel
                    text: "Additional Geth args: "
                }

                TextField {
                    id: gethArgsField
                    width: parent.width - gethArgsLabel.width
                    text: settings.value("geth/args", "--fast --cache 512")
                    onTextChanged: {
                        settings.setValue("geth/args", gethArgsField.text)
                    }
                }
            }

        }
    }

}
