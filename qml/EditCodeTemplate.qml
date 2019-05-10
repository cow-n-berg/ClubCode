import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    property variant context
    property var valid_ean8: RegExpValidator {
        regExp: /^[0-9]{7,8}$/
    }
    property var valid_ean13: RegExpValidator {
        regExp: /^[0-9]{12,13}$/
    }
    property var valid_code128: RegExpValidator {
        regExp: /[a-zA-Z0-9]+/
    }
    property var valid_code39: RegExpValidator {
        regExp: /[A-Z0-9-.$/+% ]+/
    }
    property var valid_code93: RegExpValidator {
        regExp: /[A-Z0-9-.$/+% ]+/
    }
    property var valid_upce: RegExpValidator {
        regExp: /^[0,1]{1}[0-9]{7}$/
    }
    property var valid_upca: RegExpValidator {
        regExp: /^[0-9]{12}$/
    }
    property var valid_qrcode: RegExpValidator {
    }
    property var valid_kix: RegExpValidator {
        regExp: /^[0-9]{4}[a-zA-Z]{2}[0-9]{1,5}X{0,1}[a-zA-Z0-9]{0,6}$/
    }

    width: parent.width

    function barcode_length() {
        if (barcode_type.currentIndex === 0) {
            return true
        }
        if (barcode_type.currentIndex === 1) {
            if (code.text.trim().length === 7 || code.text.trim().length === 8)
                return true
        }
        if (barcode_type.currentIndex === 2) {
            if (code.text.trim().length === 12 || code.text.trim(
                        ).length === 13)
                return true
        }
        if (barcode_type.currentIndex === 5) {
            if (code.text.trim().length === 6 || code.text.trim().length === 7)
                return true
        }
        return false
    }

    ComboBox {
        id: barcode_type
        label: qsTr("Barcode type")
        currentIndex: context.barcodeType
        menu: ContextMenu {
            MenuItem {
                text: qsTr("Code 128")
            } // 0
            MenuItem {
                text: qsTr("EAN 8")
            } // 1
            MenuItem {
                text: qsTr("EAN 13")
            } // 2
            MenuItem {
                text: qsTr("Code 39")
            } // 3
            MenuItem {
                text: qsTr("Code 93")
            } // 4
            MenuItem {
                text: qsTr("UPC-E")
            } // 5
            MenuItem {
                text: qsTr("UPC-A")
            } // 6
            MenuItem {
                text: qsTr("QR-Code")
            } // 7
            MenuItem {
                text: qsTr("KIX")
            } // 8
        }
        Binding {
            target: context
            property: "barcodeType"
            value: barcode_type.currentIndex
        }
    }

    TextField {
        focus: true
        placeholderText: qsTr("Name")
        label: placeholderText
        width: parent.width
        id: name
        text: context.name

        // Show 'next' icon to indicate pressing Enter will move the
        // keyboard focus to the next text field in the page
        EnterKey.iconSource: "image://theme/icon-m-enter-next"

        // When Enter key is pressed, move the keyboard focus to the
        // next field
        EnterKey.onClicked: description.focus = true

        Binding {
            target: context
            property: "name"
            value: name.text
        }
    }

    TextField {
        placeholderText: qsTr("Description")
        label: placeholderText
        width: parent.width
        id: description
        text: context.description

        // Show 'next' icon to indicate pressing Enter will move the
        // keyboard focus to the next text field in the page
        EnterKey.iconSource: "image://theme/icon-m-enter-next"

        // When Enter key is pressed, move the keyboard focus to the
        // next field
        EnterKey.onClicked: code.focus = true

        Binding {
            target: context
            property: "description"
            value: description.text
        }
    }

    TextField {
        id: code
        placeholderText: qsTr("Code")
        inputMethodHints: if (barcode_type.currentIndex === 0) {
                              Qt.ImhNoPredictiveText
                          } else if (barcode_type.currentIndex === 1) {
                              Qt.ImhDigitsOnly
                          } else if (barcode_type.currentIndex === 2) {
                              Qt.ImhDigitsOnly
                          } else if (barcode_type.currentIndex === 3) {
                              Qt.ImhUppercaseOnly | Qt.ImhNoPredictiveText
                          } else if (barcode_type.currentIndex === 4) {
                              Qt.ImhUppercaseOnly | Qt.ImhNoPredictiveText
                          } else if (barcode_type.currentIndex === 5) {
                              Qt.ImhDigitsOnly
                          } else if (barcode_type.currentIndex === 6) {
                              Qt.ImhDigitsOnly
                          } else if (barcode_type.currentIndex === 7) {
                              Qt.ImhNoPredictiveText
                          } else if (barcode_type.currentIndex === 8) {
                              Qt.ImhNoPredictiveText
                          }
        EnterKey.enabled: barcode_length()
        validator: if (barcode_type.currentIndex === 0) {
                       valid_code128
                   } else if (barcode_type.currentIndex === 1) {
                       valid_ean8
                   } else if (barcode_type.currentIndex === 2) {
                       valid_ean13
                   } else if (barcode_type.currentIndex === 3) {
                       valid_code39
                   } else if (barcode_type.currentIndex === 4) {
                       valid_code93
                   } else if (barcode_type.currentIndex === 5) {
                       valid_upce
                   } else if (barcode_type.currentIndex === 6) {
                       valid_upca
                   } else if (barcode_type.currentIndex === 7) {
                       valid_qrcode
                   } else if (barcode_type.currentIndex === 8) {
                       valid_kix
                   }
        label: placeholderText
        width: parent.width
        text: context.code

        // When Enter key is pressed, move the keyboard focus to the
        // next field
        EnterKey.onClicked: accept()

        Binding {
            target: context
            property: "code"
            value: code.text
        }
    }
}
