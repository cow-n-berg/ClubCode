#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QtQml>
#include <QFontDatabase>
#include <QQuickView>
#include <QtGui>

#include "AddNewCodePageViewModel.h"
#include "MainViewModel.h"
#include "BarcodeImageProvider.h"
#include "EditCodePageViewModel.h"
#include "settings.h"
#include "QrCodeGenerator.h"
#include "QrCodeImageProvider.h"


int main(int argc, char *argv[]) {
    qmlRegisterType<MainViewModel>("harbour.clubcode", 1, 0, "MainViewModel");
    qmlRegisterType<AddNewCodePageViewModel>("harbour.clubcode", 1, 0, "AddNewCodePageViewModel");
    qmlRegisterType<EditCodePageViewModel>("harbour.clubcode", 1, 0, "EditCodePageViewModel");
    qmlRegisterType<QrCodeGenerator>("harbour.clubcode", 1, 0, "QrCodeGenerator");

    QGuiApplication *application = SailfishApp::application(argc, argv);
    QQuickView *view = SailfishApp::createView();
    QQmlContext* context = view->rootContext();
    QQmlEngine* engine = context->engine();

    QFontDatabase fontDatabase;
    fontDatabase.addApplicationFont(":/fonts/code128.ttf");
    fontDatabase.addApplicationFont(":/fonts/ean13.ttf");
    fontDatabase.addApplicationFont(":/fonts/code39.ttf");
    fontDatabase.addApplicationFont(":/fonts/code93.ttf");
    fontDatabase.addApplicationFont(":/fonts/upc-a.ttf");
    fontDatabase.addApplicationFont(":/fonts/upc-e.ttf");

    engine->addImageProvider("qrcode", new QrCodeImageProvider);

    qmlRegisterType<Settings>("harbour.clubcode.Settings", 1 , 0 , "MySettings");

    view->setSource(SailfishApp::pathTo("qml/harbour-clubcode.qml"));
    view->showFullScreen();

    return application->exec();
}
