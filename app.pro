TARGET = harbour-clubcode

CONFIG += sailfishapp link_pkgconfig
PKGCONFIG += sailfishapp
DEPLOYMENT_PATH = /usr/share/$${TARGET}

QMAKE_CXXFLAGS += -Wno-unused-parameter -Wno-psabi
QMAKE_CFLAGS += -Wno-unused-parameter

LIBQRENCODE_DIR = $${_PRO_FILE_PWD_}/libqrencode

# Libraries
LIBS += libqrencode.a -ldl

# Directories
HARBOUR_LIB_REL = harbour-lib
HARBOUR_LIB_DIR = $${_PRO_FILE_PWD_}/$${HARBOUR_LIB_REL}
HARBOUR_LIB_INCLUDE = $${HARBOUR_LIB_DIR}/include
HARBOUR_LIB_SRC = $${HARBOUR_LIB_DIR}/src

SOURCES += \
    src/MainViewModel.cpp \
    src/CodeViewModel.cpp \
    src/AddNewCodePageViewModel.cpp \
    src/EditCodePageViewModel.cpp \
    src/settings.cpp \
    src/main.cpp \
    src/QrCodeGenerator.cpp \
    src/QrCodeImageProvider.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    rpm/harbour-clubcode.changes.in \
    translations/*.ts \
    qml/pages/ViewCodePage.qml \
    qml/EditCodeTemplate.qml \
    qml/pages/EditCodePage.qml \
    qml/pages/AddNewCodePage.qml \
    qml/pages/HomePage.qml \
    qml/pages/SettingPage.qml \
    qml/pages/QrCodePage.qml \
    qml/pages/About.qml \
    qml/harbour-clubcode.qml \
    rpm/harbour-clubcode.spec \
    harbour-clubcode.desktop

INCLUDEPATH += \
    src \
    /usr/include/qt5 \
    $${LIBQRENCODE_DIR}

INSTALLS += translations

TRANSLATIONS = translations/harbour-clubcode-ru.ts \
               translations/harbour-clubcode-zh_cn.ts \
               translations/harbour-clubcode-fr.ts \
               translations/harbour-clubcode-sv.ts \
               translations/harbour-clubcode-cs.ts

HEADERS += \
    src/MainViewModel.h \
    src/CodeViewModel.h \
    src/AddNewCodePageViewModel.h \
    src/settings.h \
    src/EditCodePageViewModel.h \
    src/QrCodeGenerator.h \
    src/QrCodeImageProvider.h

# harbour-lib

INCLUDEPATH += \
    $${HARBOUR_LIB_DIR}/include

HEADERS += \
    $${HARBOUR_LIB_INCLUDE}/HarbourBase32.h \
    $${HARBOUR_LIB_INCLUDE}/HarbourDebug.h \
    $${HARBOUR_LIB_INCLUDE}/HarbourImageProvider.h \
#    $${HARBOUR_LIB_INCLUDE}/HarbourOrganizeListModel.h \
#    $${HARBOUR_LIB_INCLUDE}/HarbourSystemState.h \
    $${HARBOUR_LIB_INCLUDE}/HarbourTask.h \
    $${HARBOUR_LIB_INCLUDE}/HarbourTheme.h \
#    $${HARBOUR_LIB_SRC}/HarbourMce.h

SOURCES += \
    $${HARBOUR_LIB_SRC}/HarbourBase32.cpp \
    $${HARBOUR_LIB_SRC}/HarbourImageProvider.cpp \
#    $${HARBOUR_LIB_SRC}/HarbourMce.cpp \
#    $${HARBOUR_LIB_SRC}/HarbourOrganizeListModel.cpp \
#    $${HARBOUR_LIB_SRC}/HarbourSystemState.cpp \
    $${HARBOUR_LIB_SRC}/HarbourTask.cpp \
    $${HARBOUR_LIB_SRC}/HarbourTheme.cpp

RESOURCES += \
    Resources.qrc

resources.files = cover.png
resources.path = /usr/share/$${TARGET}

# only include these files for translation:
lupdate_only {
    SOURCES = qml/*.qml \
              qml/pages/*.qml
}

translations.files = translations
translations.path = $${DEPLOYMENT_PATH}

INSTALLS += resources

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
