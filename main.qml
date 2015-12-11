import QtQuick 2.3
import QtQuick.Controls 1.3 as QuickControls
import Material 0.1

ApplicationWindow {
    title: "Name Generator"
    id: app

    property variant jsonData: null

    Component.onCompleted: {
        var request = new XMLHttpRequest()
        request.open('GET', 'names.json')
        request.onreadystatechange = function(event) {
            if (request.readyState !== XMLHttpRequest.DONE) return;
            jsonData = JSON.parse(request.responseText)
            app.visible = true
        }
        request.send()
    }

    theme {
        primaryColor: Palette.colors["blue"]["500"]
        accentColor: Palette.colors["red"]["A200"]
    }

    Column {
        anchors.fill: parent
        anchors.leftMargin: Units.dp(20)
        anchors.rightMargin: anchors.leftMargin
        spacing: Units.dp(20)

        Label {
            text: "Name Generator"
            style: "display2"
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.primaryColor
        }

        Column {
            Label {
                text: "Gender"
                style: "title"
            }

            Row {
                QuickControls.ExclusiveGroup { id: genderGroup }

                RadioButton {
                    checked: true
                    text: "Random"
                    exclusiveGroup: genderGroup
                }

                RadioButton {
                    id: genderMale
                    text: "Male"
                    exclusiveGroup: genderGroup
                }

                RadioButton {
                    id: genderFemale
                    text: "Female"
                    exclusiveGroup: genderGroup
                }
            }
        }

        Column {
            Label {
                text: "Last Name"
                style: "title"
            }

            Row {
                QuickControls.ExclusiveGroup { id: lastNameGroup }

                RadioButton {
                    id: showLastName
                    checked: true
                    text: "Yes"
                    exclusiveGroup: lastNameGroup
                }

                RadioButton {
                    text: "No"
                    exclusiveGroup: lastNameGroup
                }
            }
        }

        Button {
            text: "Generate"
            backgroundColor: Theme.primaryColor

            onClicked: {
                var m = jsonData.male[Math.floor(Math.random() * jsonData.male.length)]
                var f = jsonData.female[Math.floor(Math.random() * jsonData.female.length)]
                var l = jsonData.last[Math.floor(Math.random() * jsonData.last.length)]

                if (genderMale.checked) nameField.text = m;
                else if (genderFemale.checked) nameField.text = f;
                else nameField.text = (Math.random() > 0.5) ? m : f;

                if (showLastName.checked) nameField.text += " " + l
            }
        }

        Label {
            id: nameField
            style: "headline"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
