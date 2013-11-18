/* Copyright (c) 2013 Ekkehard Gentz (ekke)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.2

Page {
    property variant scaling: 2.0/3.0
    Container {
        Label {
            text: "ScaleFactor"
        }
        Label {
            id: valueLabel
            text: scaling
        }
        Label {
            text: "a width of 1280px will be scaled to " + Math.round(1280/scaling) + "px"
        }
        Slider {
            id: scaleSlider
            fromValue: 0.1
            toValue: 0.9
            value: 2.0/3.0
            onValueChanged: {
                scaling =  "0."+Math.round(value*1000)
            }
        }
        Button {
            text: "Default (2/3)"
            onClicked: {
                scaleSlider.value = 2.0/3.0
            }
        }
    }
    
}
