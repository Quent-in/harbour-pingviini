# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-pingviini

CONFIG += sailfishapp

SOURCES += src/harbour-pingviini.cpp \
    src/selector/exif/exif.cpp \
    src/selector/thumbnailprovider.cpp \
    src/selector/filesmodel.cpp \
    src/selector/imageuploader.cpp \
    src/selector/filesmodelworker.cpp

OTHER_FILES += qml/harbour-pingviini.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    lib/* \
    qml/pages/cmp/Stats.qml \
    qml/pages/JSONListModel.qml \
    qml/pages/TweetToolBar.qml \
    qml/lib/common.js \
    qml/lib/Worker.js \
    qml/lib/codebird.js \
    qml/lib/Logic.js \
    rpm/harbour-pingviini.changes.in \
    rpm/harbour-pingviini.spec \
    rpm/harbour-pingviini.yaml \
    translations/*.ts \
    harbour-pingviini.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-pingviini-de.ts

DISTFILES += \
    Logic.js \
    oauth.js \
    sha1.js \
    qml/pages/AccountAdd.qml \
    qml/component/Tweet.qml \
    qml/pages/Navigation.qml \
    qml/pages/CmpDirectMessages.qml \
    qml/pages/SearchView.qml \
    qml/pages/jsonpath.js \
    qml/pages/NewTweet.qml \
    qml/pages/TweetDetails.qml \
    qml/pages/Splash.qml \
    qml/pages/Browser.qml \
    qml/pages/Conversation.qml \
    qml/logo.svg \
    qml/pages/Profile.qml \
    qml/pages/cmp/ProfileHeader.qml \
    qml/pages/cmp/PingviiniiLogo.qml \
    qml/pages/ImageChooser.qml \
    qml/pages/cmp/Tweet.qml \
    qml/pages/cmp/MediaBlock.qml \
    qml/pages/cmp/MyImage.qml \
    qml/pages/ImageFullScreen.qml \
    qml/home.svg \
    qml/mesagess.svg \
    qml/search.svg \
    qml/verified.svg \
    qml/pages/cmp/MyList.qml \
    qml/pages/cmp/TweetVideo.qml \
    qml/pages/Settings.qml \
    qml/pages/CreditsTranslations.qml

HEADERS += \
    src/selector/imageuploader.h \
    src/selector/exif/exif.h \
    src/selector/filesmodel.h \
    src/selector/filesmodelworker.h
