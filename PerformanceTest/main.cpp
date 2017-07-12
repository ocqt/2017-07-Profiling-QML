#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    // Show scene graph
    // Uncomment to show performance data
//    qputenv("QSG_VISUALIZE", "batches");
//    qputenv("QSG_VISUALIZE", "clip");
//    qputenv("QSG_VISUALIZE", "changes");
//    qputenv("QSG_VISUALIZE", "overdraw");
//    qputenv("QSG_RENDERER_DEBUG", "render");
//    qputenv("QSG_RENDER_TIMING", "1");

    /*
    // Paste into Project environment setting
    QSG_VISUALIZE=batches
    QSG_VISUALIZE=clip
    QSG_VISUALIZE=changes
    QSG_VISUALIZE=overdraw
    QSG_RENDERER_DEBUG=render
    QSG_RENDER_TIMING=1
    */

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
