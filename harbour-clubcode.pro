TARGET = harbour-clubcode

CONFIG += sailfishapp
DEPLOYMENT_PATH = /usr/share/$${TARGET}

SOURCES += \
    src/MainViewModel.cpp \
    src/CodeViewModel.cpp \
    src/AddNewCodePageViewModel.cpp \
    src/EditCodePageViewModel.cpp \
    src/settings.cpp \
    src/main.cpp

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
    qml/pages/About.qml \
    qml/harbour-clubcode.qml \
    rpm/harbour-clubcode.yaml \
    rpm/harbour-clubcode.spec \
    harbour-clubcode.desktop

INSTALLS += translations

TRANSLATIONS = translations/harbour-clubcode-ru.ts \
               translations/harbour-clubcode-zh_cn.ts \
               translations/harbour-clubcode-fr.ts \
               translations/harbour-clubcode-cs.ts

HEADERS += \
    src/MainViewModel.h \
    src/CodeViewModel.h \
    src/AddNewCodePageViewModel.h \
    src/settings.h \
    src/EditCodePageViewModel.h

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
