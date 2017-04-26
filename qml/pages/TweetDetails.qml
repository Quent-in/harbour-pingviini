/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../lib/Logic.js" as Logic
import "./cmp/"

Page {
    property ListModel tweets;
    property string selected;
    property string screenName;
    property string tweetType: "New";


    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All
    Component.onCompleted: {

    }

    ProfileHeader {
        id: header
        title: tweets.get(selected).name
        description: '@'+screenName
        image: tweets.get(selected).profileImageUrl
    }

    NewTweet {
        id: tweetPanel
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        type: tweetType
        tweetId: tweets.get(selected).id_str;
        placedText: screenName ? '@'+screenName : ""
    }

    SilicaListView {
        id: listView
        model: 1
        anchors {
            top: header.bottom
            bottom: tweetPanel.top
            left: parent.left
            right: parent.right
        }
        clip: true

        header: Item {
            width: parent.width
            height:  Theme.paddingLarge*2+ lblText.paintedHeight + mediaImg.height + ( mediaImg.height > 0 ? Theme.paddingLarge : 0)


            Text {
                id: lblText
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    topMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                    leftMargin: Theme.paddingLarge
                }
                height: paintedHeight
                text: tweets.get(selected).richText
                textFormat:Text.RichText
                onLinkActivated: console.log(link + " link activated")
                linkColor : Theme.highlightColor
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeMedium
                color: (pressed ? Theme.highlightColor : Theme.primaryColor)
            }
            Image {
                id: mediaImg
                anchors {
                    left: parent.left
                    right: parent.right
                    top: lblText.bottom
                    topMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                    leftMargin: Theme.paddingLarge
                }
                opacity: pressed ? 0.6 : 1
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                width: 200
                height: 0
                visible: {
                    if (tweets.get(selected).mediaUrl){
                        source = tweets.get(selected).mediaUrl
                        height = 200
                        return true
                    } else {
                        height = 0
                        return false
                    }
                }
                Component.onCompleted: {
                    height = (sourceSize.height*width)/sourceSize.width
                    console.log(sourceSize.height)
                }
            }

        }


        /**/
        delegate: BackgroundItem {
            id: delegate

            Label {
                x: Theme.horizontalPageMargin
                text: qsTr("Item") + " " + index
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: function(){
                console.log("Clicked " + index)
            }
        }
        VerticalScrollDecorator {}
    }

}