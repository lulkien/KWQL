#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("WINDOW_WIDTH",    1920);
    engine.rootContext()->setContextProperty("WINDOW_HEIGHT",   1080);

    engine.rootContext()->setContextProperty("ITEM_WIDTH",      720);
    engine.rootContext()->setContextProperty("ITEM_HEIGHT",     320);
    engine.rootContext()->setContextProperty("ITEM_SPACING",    100);


    engine.load(QStringLiteral("qrc:/main.qml"));

    return app.exec();
}
