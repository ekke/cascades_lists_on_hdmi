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
NavigationPane {
    property ScaleSliderPage scaleSliderPage : null
    // 2nd screen
    property variant scaleFactor: 2.0 / 3.0 // 1280 --> 1920
    property bool use2ndScreen: false
    onUse2ndScreenChanged: {
        // current orientation is Landscape ? scale immediately
        if (OrientationSupport.orientation == UIOrientation.Landscape) {
            scaled = use2ndScreen
        }
    }
    onScaleFactorChanged: {
        // current orientation is Landscape AND already scaled ? re-scale immediately
        if (scaled && OrientationSupport.orientation == UIOrientation.Landscape) {
            scaleListView()
        }
    }
    // this is the trigger to scale the ListView for HDMI or Device
    property bool scaled: false
    onScaledChanged: {
        scaleListView()
    }
    id: navigationPane
    attachedObjects: [
        OrientationHandler {
            onOrientationAboutToChange: {
                // normaly I'm doing all resizing depending on OrientationChange here
                // to do the scaling-stuff for 2nd Screen we have to wait for signal orientationChanged
                // or we can do it in the LayoutHandler itself as I'm doing here
            }
        },
        GroupDataModel {
            id: scoresDataModel
            sortingKeys: [ "score" ]
            grouping: ItemGrouping.ByFullValue
            sortedAscending: false
        },
        ComponentDefinition {
            id: scaleSliderPageComponent
            source: "ScaleSliderPage.qml"
        }
    ]

    Page {
        id: listPage
        titleBar: TitleBar {
            title: "Scorelist on Device || HDMI"
        }
        actions: [
            ActionItem {
                title: use2ndScreen ? "On Device" : "On 2nd Screen"
                imageSource: use2ndScreen ? "asset:///images/device.png" : "asset:///images/ic_hdmi.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    use2ndScreen = ! use2ndScreen
                }
            },
            ActionItem {
                title: "scale 2/3"
                ActionBar.placement: ActionBarPlacement.InOverflow
                onTriggered: {
                    scaleFactor = 2.0 / 3.0
                }
            },
            ActionItem {
                title: "scale 1/2"
                ActionBar.placement: ActionBarPlacement.InOverflow
                onTriggered: {
                    scaleFactor = 0.5
                }
            },
            ActionItem {
                title: "scale 1/3"
                ActionBar.placement: ActionBarPlacement.InOverflow
                onTriggered: {
                    scaleFactor = 1.0 / 3.0
                }
            },
            ActionItem {
                title: "scale 1/4"
                ActionBar.placement: ActionBarPlacement.InOverflow
                onTriggered: {
                    scaleFactor = 0.25
                }
            },
            ActionItem {
                title: "Slider"
                ActionBar.placement: ActionBarPlacement.InOverflow
                onTriggered: {
                    scaleSliderPage = scaleSliderPageComponent.createObject()
                    navigationPane.push(scaleSliderPage)
                }
            }
        ]
        Container {
            id: outerContainer
            attachedObjects: [
                LayoutUpdateHandler {
                    id: listViewLayoutHandler
                    onLayoutFrameChanged: {
                        console.log("onLayoutFrameChanged:")
                        console.log("LIST LAYOUT w: " + layoutFrame.width + " h: " + layoutFrame.height)
                        console.log("LIST LAYOUT x: " + layoutFrame.x + " y: " + layoutFrame.y)
                        if (use2ndScreen) {
                            if (layoutFrame.width <= layoutFrame.height) {
                                // PORTRAIT or SQUARE
                                scaled = false
                            } else {
                                scaled = true
                            }
                        }
                    }
                }
            ]
            ListView {
                id: listView
                dataModel: scoresDataModel
                listItemComponents: [
                    ListItemComponent {
                        id: headerItem
                        type: "header"
                        Container {
                            // nothing
                        }
                    },
                    ListItemComponent {
                        id: scoreItem
                        type: "item"
                        ScorelistItem {
                            id: itemRoot
                        }
                    }
                ]
                onTriggered: {
                    // do something: push page or so
                }
                function itemType(data, indexPath) {
                    if (indexPath.length == 1) {
                        return "header"
                    }
                    return "item"
                }
            }
        }
        onPeekStarted: {
            scaleFactor = scaleSliderPage.scaling
        }
    } // end listPage
    function scaleListView() {
        // scaling must be done on the ListView - not the outerContainer
        var extendFactor = 1 / scaleFactor
        if (scaled) {
            listView.scaleX = scaleFactor
            listView.scaleY = scaleFactor
            listView.minWidth = listViewLayoutHandler.layoutFrame.width * extendFactor //1920
            listView.minHeight = listViewLayoutHandler.layoutFrame.height * extendFactor // 1080 - 260
            listView.translationX = (listView.minWidth - listViewLayoutHandler.layoutFrame.width) / -2 // -320
            listView.translationY = (listView.minHeight - listViewLayoutHandler.layoutFrame.height) / -2 // -136 // 180
        } else {
            listView.scaleX = 1
            listView.scaleY = 1
            listView.minWidth = 0
            listView.minHeight = 0
            listView.translationX = 0
            listView.translationY = 0
        }
    }
    onPopTransitionEnded: {
    	scaleFactor = scaleSliderPage.scaling
        scaleSliderPage.destroy()
    }
    onCreationCompleted: {
        scoresDataModel.insertList(app.itemsList())
        // Attention
        // we cannot ask listViewLayoutHandler about frame sizes
        // always 0 here
        // we have to wait for the first event from onLayoutFrameChanged
    }
}
