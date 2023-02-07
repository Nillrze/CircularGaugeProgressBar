import QtQuick 2.15
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4

import "../"

Item {
    id : circularGaugeItem
    width: 120
    height: 120

    property alias ptyValue: control.value
    property alias ptyTitle: txtTitle.text
    property color ptyCircleGaugeBackground: "#353535"
    property int   ptyCircleGaugeBackgroundHeight: 16 // circularGaugeItem.width / 16

    CircularGauge {
        id: control
        width: parent.width
        height: parent.height

        style: CircularGaugeStyle {
            minimumValueAngle: -90
            maximumValueAngle: 90
            labelStepSize: 0

            function degreesToRadians(degrees) {
                return degrees * (Math.PI / 180);
            }

            needle:        Rectangle { visible: false }
            foreground:    Item { Rectangle { visible: false } }
            tickmark:      Rectangle { visible: false }
            minorTickmark: Rectangle { visible: false }



            background: Canvas {
                id:canvasBack

                Connections {
                    target: circularGaugeItem
                    function onPtyValueChanged() {
                        canvasBack.requestPaint()
                    }
                }

                onPaint:
                {
                    var ctx=getContext("2d");
                    ctx.reset();

                    //Draw Full Background
                    ctx.beginPath();
                    ctx.strokeStyle = ptyCircleGaugeBackground
                    ctx.lineWidth = ptyCircleGaugeBackgroundHeight;
                    ctx.lineCap = 'round';
                    ctx.arc(outerRadius,
                            outerRadius,
                            outerRadius-ctx.lineWidth/2,
                            degreesToRadians(valueToAngle(0)-90),
                            degreesToRadians(valueToAngle(100)-90));
                    ctx.stroke();
                    console.log(outerRadius)

                    //Draw  value
                    var gradient = ctx.createLinearGradient(0, outerRadius, outerRadius*2, outerRadius);
                    gradient.addColorStop(0,     '#1FBE72');
                    gradient.addColorStop(0.25,  '#FFBD39');
                    gradient.addColorStop(0.6,   '#FF7A00');
                    gradient.addColorStop(1.00,  '#FD5B4C');

                    ctx.beginPath();
                    ctx.arc(outerRadius,
                            outerRadius,
                            outerRadius-ctx.lineWidth/2,
                            degreesToRadians(valueToAngle(0)-90),
                            degreesToRadians(valueToAngle(control.value)-90));
                    ctx.strokeStyle = gradient;
                    ctx.lineWidth = ptyCircleGaugeBackgroundHeight;
                    ctx.lineCap = 'round';
                    ctx.stroke();

                }  // onPaint
            }  // background
        }
    }

    Text {
        id: txtPercent
        text: ptyValue + "%"
        font { family: Style.fontProductSansRegular; pixelSize: 17; bold: true }
        color: Style.ptyColorWhite
        anchors.horizontalCenter: control.horizontalCenter
        anchors.verticalCenter: control.verticalCenter
    }

    Text {
        id: txtTitle
        font { family: Style.fontProductSansRegular; pixelSize: 20; bold: true }
        opacity: 0.6
        color: Style.ptyColorWhite
        anchors { top: txtPercent.bottom; topMargin: 12; horizontalCenter: control.horizontalCenter }
    }
}
