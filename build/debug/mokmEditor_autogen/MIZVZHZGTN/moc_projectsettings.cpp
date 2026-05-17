/****************************************************************************
** Meta object code from reading C++ file 'projectsettings.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.11.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../motionEditor/src/providers/projectsettings.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'projectsettings.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.11.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN15ProjectSettingsE_t {};
} // unnamed namespace

template <> constexpr inline auto ProjectSettings::qt_create_metaobjectdata<qt_meta_tag_ZN15ProjectSettingsE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "ProjectSettings",
        "projectNameChanged",
        "",
        "widthChanged",
        "heightChanged",
        "frameRateChanged",
        "pixelAspectRatioChanged",
        "durationChanged",
        "audioSampleRateChanged",
        "colorSpaceChanged",
        "bitDepthChanged",
        "proxyResolutionChanged",
        "enable3DChanged",
        "rendererChanged",
        "vectorEngineChanged",
        "setProjectName",
        "name",
        "setWidth",
        "w",
        "setHeight",
        "h",
        "setFrameRate",
        "fps",
        "setPixelAspectRatio",
        "par",
        "setDuration",
        "secs",
        "setAudioSampleRate",
        "rate",
        "setColorSpace",
        "cs",
        "setBitDepth",
        "depth",
        "setProxyResolution",
        "px",
        "setEnable3D",
        "enable",
        "setRenderer",
        "r",
        "setVectorEngine",
        "ve",
        "projectName",
        "width",
        "height",
        "frameRate",
        "pixelAspectRatio",
        "duration",
        "audioSampleRate",
        "colorSpace",
        "bitDepth",
        "proxyResolution",
        "enable3D",
        "renderer",
        "vectorEngine"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'projectNameChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'widthChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'heightChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'frameRateChanged'
        QtMocHelpers::SignalData<void()>(5, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'pixelAspectRatioChanged'
        QtMocHelpers::SignalData<void()>(6, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'durationChanged'
        QtMocHelpers::SignalData<void()>(7, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'audioSampleRateChanged'
        QtMocHelpers::SignalData<void()>(8, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'colorSpaceChanged'
        QtMocHelpers::SignalData<void()>(9, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'bitDepthChanged'
        QtMocHelpers::SignalData<void()>(10, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'proxyResolutionChanged'
        QtMocHelpers::SignalData<void()>(11, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'enable3DChanged'
        QtMocHelpers::SignalData<void()>(12, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'rendererChanged'
        QtMocHelpers::SignalData<void()>(13, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'vectorEngineChanged'
        QtMocHelpers::SignalData<void()>(14, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'setProjectName'
        QtMocHelpers::SlotData<void(const QString &)>(15, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 16 },
        }}),
        // Slot 'setWidth'
        QtMocHelpers::SlotData<void(int)>(17, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 18 },
        }}),
        // Slot 'setHeight'
        QtMocHelpers::SlotData<void(int)>(19, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 20 },
        }}),
        // Slot 'setFrameRate'
        QtMocHelpers::SlotData<void(double)>(21, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Double, 22 },
        }}),
        // Slot 'setPixelAspectRatio'
        QtMocHelpers::SlotData<void(double)>(23, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Double, 24 },
        }}),
        // Slot 'setDuration'
        QtMocHelpers::SlotData<void(double)>(25, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Double, 26 },
        }}),
        // Slot 'setAudioSampleRate'
        QtMocHelpers::SlotData<void(int)>(27, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 28 },
        }}),
        // Slot 'setColorSpace'
        QtMocHelpers::SlotData<void(const QString &)>(29, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 30 },
        }}),
        // Slot 'setBitDepth'
        QtMocHelpers::SlotData<void(int)>(31, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 32 },
        }}),
        // Slot 'setProxyResolution'
        QtMocHelpers::SlotData<void(int)>(33, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 34 },
        }}),
        // Slot 'setEnable3D'
        QtMocHelpers::SlotData<void(bool)>(35, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 36 },
        }}),
        // Slot 'setRenderer'
        QtMocHelpers::SlotData<void(const QString &)>(37, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 38 },
        }}),
        // Slot 'setVectorEngine'
        QtMocHelpers::SlotData<void(const QString &)>(39, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 40 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'projectName'
        QtMocHelpers::PropertyData<QString>(41, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 0),
        // property 'width'
        QtMocHelpers::PropertyData<int>(42, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 1),
        // property 'height'
        QtMocHelpers::PropertyData<int>(43, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 2),
        // property 'frameRate'
        QtMocHelpers::PropertyData<double>(44, QMetaType::Double, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 3),
        // property 'pixelAspectRatio'
        QtMocHelpers::PropertyData<double>(45, QMetaType::Double, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 4),
        // property 'duration'
        QtMocHelpers::PropertyData<double>(46, QMetaType::Double, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 5),
        // property 'audioSampleRate'
        QtMocHelpers::PropertyData<int>(47, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 6),
        // property 'colorSpace'
        QtMocHelpers::PropertyData<QString>(48, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 7),
        // property 'bitDepth'
        QtMocHelpers::PropertyData<int>(49, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 8),
        // property 'proxyResolution'
        QtMocHelpers::PropertyData<int>(50, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 9),
        // property 'enable3D'
        QtMocHelpers::PropertyData<bool>(51, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 10),
        // property 'renderer'
        QtMocHelpers::PropertyData<QString>(52, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 11),
        // property 'vectorEngine'
        QtMocHelpers::PropertyData<QString>(53, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 12),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<ProjectSettings, qt_meta_tag_ZN15ProjectSettingsE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject ProjectSettings::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN15ProjectSettingsE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN15ProjectSettingsE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN15ProjectSettingsE_t>.metaTypes,
    nullptr
} };

void ProjectSettings::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<ProjectSettings *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->projectNameChanged(); break;
        case 1: _t->widthChanged(); break;
        case 2: _t->heightChanged(); break;
        case 3: _t->frameRateChanged(); break;
        case 4: _t->pixelAspectRatioChanged(); break;
        case 5: _t->durationChanged(); break;
        case 6: _t->audioSampleRateChanged(); break;
        case 7: _t->colorSpaceChanged(); break;
        case 8: _t->bitDepthChanged(); break;
        case 9: _t->proxyResolutionChanged(); break;
        case 10: _t->enable3DChanged(); break;
        case 11: _t->rendererChanged(); break;
        case 12: _t->vectorEngineChanged(); break;
        case 13: _t->setProjectName((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 14: _t->setWidth((*reinterpret_cast<std::add_pointer_t<int>>(_a[1]))); break;
        case 15: _t->setHeight((*reinterpret_cast<std::add_pointer_t<int>>(_a[1]))); break;
        case 16: _t->setFrameRate((*reinterpret_cast<std::add_pointer_t<double>>(_a[1]))); break;
        case 17: _t->setPixelAspectRatio((*reinterpret_cast<std::add_pointer_t<double>>(_a[1]))); break;
        case 18: _t->setDuration((*reinterpret_cast<std::add_pointer_t<double>>(_a[1]))); break;
        case 19: _t->setAudioSampleRate((*reinterpret_cast<std::add_pointer_t<int>>(_a[1]))); break;
        case 20: _t->setColorSpace((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 21: _t->setBitDepth((*reinterpret_cast<std::add_pointer_t<int>>(_a[1]))); break;
        case 22: _t->setProxyResolution((*reinterpret_cast<std::add_pointer_t<int>>(_a[1]))); break;
        case 23: _t->setEnable3D((*reinterpret_cast<std::add_pointer_t<bool>>(_a[1]))); break;
        case 24: _t->setRenderer((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 25: _t->setVectorEngine((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (ProjectSettings::*)()>(_a, &ProjectSettings::projectNameChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (ProjectSettings::*)()>(_a, &ProjectSettings::widthChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (ProjectSettings::*)()>(_a, &ProjectSettings::heightChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (ProjectSettings::*)()>(_a, &ProjectSettings::frameRateChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (ProjectSettings::*)()>(_a, &ProjectSettings::pixelAspectRatioChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (ProjectSettings::*)()>(_a, &ProjectSettings::durationChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (ProjectSettings::*)()>(_a, &ProjectSettings::audioSampleRateChanged, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (ProjectSettings::*)()>(_a, &ProjectSettings::colorSpaceChanged, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (ProjectSettings::*)()>(_a, &ProjectSettings::bitDepthChanged, 8))
            return;
        if (QtMocHelpers::indexOfMethod<void (ProjectSettings::*)()>(_a, &ProjectSettings::proxyResolutionChanged, 9))
            return;
        if (QtMocHelpers::indexOfMethod<void (ProjectSettings::*)()>(_a, &ProjectSettings::enable3DChanged, 10))
            return;
        if (QtMocHelpers::indexOfMethod<void (ProjectSettings::*)()>(_a, &ProjectSettings::rendererChanged, 11))
            return;
        if (QtMocHelpers::indexOfMethod<void (ProjectSettings::*)()>(_a, &ProjectSettings::vectorEngineChanged, 12))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QString*>(_v) = _t->projectName(); break;
        case 1: *reinterpret_cast<int*>(_v) = _t->width(); break;
        case 2: *reinterpret_cast<int*>(_v) = _t->height(); break;
        case 3: *reinterpret_cast<double*>(_v) = _t->frameRate(); break;
        case 4: *reinterpret_cast<double*>(_v) = _t->pixelAspectRatio(); break;
        case 5: *reinterpret_cast<double*>(_v) = _t->duration(); break;
        case 6: *reinterpret_cast<int*>(_v) = _t->audioSampleRate(); break;
        case 7: *reinterpret_cast<QString*>(_v) = _t->colorSpace(); break;
        case 8: *reinterpret_cast<int*>(_v) = _t->bitDepth(); break;
        case 9: *reinterpret_cast<int*>(_v) = _t->proxyResolution(); break;
        case 10: *reinterpret_cast<bool*>(_v) = _t->enable3D(); break;
        case 11: *reinterpret_cast<QString*>(_v) = _t->renderer(); break;
        case 12: *reinterpret_cast<QString*>(_v) = _t->vectorEngine(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setProjectName(*reinterpret_cast<QString*>(_v)); break;
        case 1: _t->setWidth(*reinterpret_cast<int*>(_v)); break;
        case 2: _t->setHeight(*reinterpret_cast<int*>(_v)); break;
        case 3: _t->setFrameRate(*reinterpret_cast<double*>(_v)); break;
        case 4: _t->setPixelAspectRatio(*reinterpret_cast<double*>(_v)); break;
        case 5: _t->setDuration(*reinterpret_cast<double*>(_v)); break;
        case 6: _t->setAudioSampleRate(*reinterpret_cast<int*>(_v)); break;
        case 7: _t->setColorSpace(*reinterpret_cast<QString*>(_v)); break;
        case 8: _t->setBitDepth(*reinterpret_cast<int*>(_v)); break;
        case 9: _t->setProxyResolution(*reinterpret_cast<int*>(_v)); break;
        case 10: _t->setEnable3D(*reinterpret_cast<bool*>(_v)); break;
        case 11: _t->setRenderer(*reinterpret_cast<QString*>(_v)); break;
        case 12: _t->setVectorEngine(*reinterpret_cast<QString*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *ProjectSettings::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ProjectSettings::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN15ProjectSettingsE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int ProjectSettings::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 26)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 26;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 26)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 26;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 13;
    }
    return _id;
}

// SIGNAL 0
void ProjectSettings::projectNameChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void ProjectSettings::widthChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void ProjectSettings::heightChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void ProjectSettings::frameRateChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void ProjectSettings::pixelAspectRatioChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void ProjectSettings::durationChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void ProjectSettings::audioSampleRateChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void ProjectSettings::colorSpaceChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 7, nullptr);
}

// SIGNAL 8
void ProjectSettings::bitDepthChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 8, nullptr);
}

// SIGNAL 9
void ProjectSettings::proxyResolutionChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 9, nullptr);
}

// SIGNAL 10
void ProjectSettings::enable3DChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 10, nullptr);
}

// SIGNAL 11
void ProjectSettings::rendererChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 11, nullptr);
}

// SIGNAL 12
void ProjectSettings::vectorEngineChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 12, nullptr);
}
QT_WARNING_POP
