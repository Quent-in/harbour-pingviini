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
    property alias title: header.title;
    property alias screenName: tweetPanel.screenName;
    property string tweetType: "Reply";
    property bool isFavourited: false;

    WorkerScript {
        id: worker
        source: "../lib/Worker.js"
        onMessage: myText.text = messageObject.reply
    }


    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All
    Component.onCompleted: {
        console.log(tweets.count)
        if (selected){
            title =  tweets.get(selected).name
            isFavourited = tweets.get(selected).isFavourited ? true : false
            header.image = tweets.get(selected).profileImageUrl

            tweetPanel.tweetId = tweets.get(selected).id_str;


            var since = tweets.get(selected).createdAt
            var until = new Date(new Date().setDate(new Date(since).getDate() + 7));
            console.log(since)
            console.log(until)
            console.log(since.toISOString().substr(0, 10))
            console.log(until.toISOString().substr(0, 10))
            var user = '@'+tweets.get(selected).screenName + (tweets.get(selected).inReplyToStatusId ? ' OR @'+tweets.get(selected).inReplyToScreenName : '')
            var msg = {
                'bgAction'    : 'search_tweets',
                'params': {
                    f: "tweets",
                    count: 100,
                    result_type: "recent",
                    q: user + ' -RT  filter:replies since:'+since.toISOString().substr(0, 10)+ ' until:'+until.toISOString().substr(0, 10),
                    since_id: tweets.get(selected).inReplyToStatusId ? tweets.get(selected).inReplyToStatusId: tweets.get(selected).id
                },
                'model'     : modelCO,
                'conf'  : Logic.getConfTW()
            };
            worker.sendMessage(msg);
        }
    }
    ListModel {
        id: modelCO
    }

    ProfileHeader {
        id: header
        title: ""
        description: screenName ? '@'+screenName : ""

    }

    NewTweet {
        id: tweetPanel
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        type: tweetType
        screenName: screenName ? screenName : ""
    }

    SilicaListView {
        id: listView
        model: modelCO
        RemorseItem { id: remorse }
        PullDownMenu {
            id: menu
            spacing: Theme.paddingLarge
            MenuItem {
                text: qsTr("Report as spam")
                onClicked: {
                    var msg = {
                        'bgAction'    : 'users_reportSpam',
                        'params': { screen_name: screenName, user_id: tweets.get(selected).userIdStr},
                        'model'     : false,
                        'conf'  : Logic.getConfTW()
                    };
                    worker.sendMessage(msg);
                }
            }
            MenuItem {
                text: qsTr("Retweet")
                onClicked: {


                    var msg = {
                        'bgAction'    : 'statuses_retweet_ID',
                        'params': { id: tweets.get(selected).id_str},
                        'model'     : false,
                        'conf'  : Logic.getConfTW()
                    };
                    worker.sendMessage(msg);
                }
            }
            MenuItem {
                text: isFavourited ? qsTr("Unfavorite") : qsTr("Favorite")
                onClicked: {
                    isFavourited  = !isFavourited ;
                    tweets.setProperty(selected, "isFavourited", isFavourited)
                    worker.sendMessage({
                                           'bgAction'    : isFavourited ? 'favorites_create' : 'favorites_destroy',
                                                                          'params': { id: tweets.get(selected).id_str},
                                           'model'     : false,
                                           'conf'  : Logic.getConfTW()
                                       });





                }
            }
        }
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
                text: selected ? tweets.get(selected).richText : ""
                height: paintedHeight
                textFormat:Text.RichText
                onLinkActivated: {
                    console.log(link)
                    if (link[0] === "@") {
                        pageStack.push(Qt.resolvedUrl("Profile.qml"), {
                                           "name": "",
                                           "username": link.substring(1),
                                           "profileImage": ""
                                       })
                    } else if (link[0] === "#") {

                            pageStack.pop(pageStack.find(function(page) {
                                var check = page.isFirstPage === true;
                                if (check)
                                    page.onLinkActivated(link)
                                return check;
                            }));

                        send(link)
                    } else {
                        pageStack.push(Qt.resolvedUrl("Browser.qml"), {"href" : link})
                    }


                }
                linkColor : Theme.highlightColor
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeMedium
                color: (pressed ? Theme.highlightColor : Theme.primaryColor)
            }
            MediaBlock {
                id: mediaImg
                anchors {
                    left: parent.left
                    right: parent.right
                    top: lblText.bottom
                    topMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                    leftMargin: Theme.paddingLarge
                }
                model: selected ? tweets.get(selected).media : false

                height: 100
            }



        }


        /**/
        delegate: Tweet{} /*BackgroundItem {
            id: delegate

            Label {
                x: Theme.horizontalPageMargin
                text: qsTr("Item") + " " + name + " | " + modelCO.count + " |"
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: function(){
                console.log("Clicked " + index + " | " + modelCO.count + " |")
            }
        }*/
        VerticalScrollDecorator {}
    }

}
