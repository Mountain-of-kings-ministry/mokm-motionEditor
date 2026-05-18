#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "someclass.h"
#include "projectsettings.h"
#include "Composition.h"
#include "Layer.h"
#include "Track.h"
#include "VideoClip.h"
#include "ThorVGClip.h"
#include "ViewportRenderer.h"
#include "AudioEngine.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<someClass>("kingClass", 1, 0, "SomeClass");
    
    // Register enums
    qmlRegisterUncreatableType<Types>("mokmME", 1, 0, "Types", "Cannot create Types in QML");
    // Compatibility aliases if needed
    // qmlRegisterUncreatableType<TrackType>("mokmME", 1, 0, "TrackType", "Cannot create enum in QML");

    // Register core compositing types
    qmlRegisterType<Composition>("mokmME", 1, 0, "Composition");
    qmlRegisterType<Layer>("mokmME", 1, 0, "Layer");
    qmlRegisterType<Track>("mokmME", 1, 0, "Track");
    qmlRegisterType<Clip>("mokmME", 1, 0, "Clip");
    qmlRegisterType<VideoClip>("mokmME", 1, 0, "VideoClip");
    qmlRegisterType<ThorVGClip>("mokmME", 1, 0, "ThorVGClip");
    qmlRegisterType<ViewportRenderer>("mokmME", 1, 0, "ViewportRenderer");
    qmlRegisterUncreatableType<mokm::AudioEngine>("mokmME", 1, 0, "AudioEngine", "Created by ProjectSettings");

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
