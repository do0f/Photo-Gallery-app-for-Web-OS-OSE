#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QString>
#include <QDebug>
#include "ImageViewier.h"
#include "PhotoContainers.h"


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    //"file:///home/doof/Pictures/images2/VG_100K_2"
    auto path = QString("file://") + qApp->applicationDirPath();
    qDebug() << path;

    auto context = engine.rootContext();
    context->setContextProperty("_picturesFolder", "file:///home/doof/Pictures/images2/VG_100K_2");

    engine.load(url);

    return app.exec();
}
