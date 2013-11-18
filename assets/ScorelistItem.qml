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

Container {
    id: rootContainer
    Container {
        id: contentContainer
        topPadding: 10
        leftPadding: 20
        rightPadding: 20
        Container {
            id: titleContainer
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            ImageView {
                imageSource: "asset:///images/icon.png"
                maxHeight: 84
                scalingMethod: ScalingMethod.AspectFit
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Left
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 0.7
                }
            }
            Label {
                text: ListItemData.vorname + " " + ListItemData.nachname
                textStyle.base: SystemDefaults.TextStyles.TitleText
                verticalAlignment: VerticalAlignment.Center
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 3.5
                }
            }
            Label {
                text: ListItemData.score
                textStyle.base: SystemDefaults.TextStyles.BigText
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1.8
                }
            }
        } // end titleContainer
    } // end contentContainer
    Divider {
    }
} // end rootContainer