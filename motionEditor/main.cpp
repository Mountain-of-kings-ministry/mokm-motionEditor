#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "someclass.h"
#include "projectsettings.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<someClass>("kingClass", 1, 0, "SomeClass");

    ProjectSettings projectSettings;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("ProjectSettings", &projectSettings);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []()
        { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("mokmME", "SplashScreen");

    return QCoreApplication::exec();
}
