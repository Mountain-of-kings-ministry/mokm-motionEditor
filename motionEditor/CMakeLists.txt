cmake_minimum_required(VERSION 3.16)

project(mokmME VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 QuickEffects)

find_package(PkgConfig REQUIRED)
pkg_check_modules(FFmpeg REQUIRED libavformat libavcodec libswscale libavutil)
pkg_check_modules(PortAudio REQUIRED portaudio-2.0)

# ThorVG integration
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../third_parties/thorvg ${CMAKE_BINARY_DIR}/thorvg)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../third_parties/dawmodule ${CMAKE_BINARY_DIR}/dawmodule)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(mokmEditor
    main.cpp
    src/resources/resources.qrc
)

add_subdirectory(src)

set_source_files_properties(src/pages/Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(src/pages/components/fragments/TrackTypeConfig.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

# Automatically find all cpp and h files in src/functions and src/core
file(GLOB_RECURSE CORE_SOURCES "src/core/*.cpp" "src/core/*.h")
file(GLOB_RECURSE FUNCTION_SOURCES "src/functions/*.cpp" "src/functions/*.h")

set(AUDIO_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/../third_parties/dawmodule/src/core/AudioEngine.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../third_parties/dawmodule/src/core/MasterBus.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../third_parties/dawmodule/src/core/Bus.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../third_parties/dawmodule/src/core/Track.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../third_parties/dawmodule/src/core/Fader.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../third_parties/dawmodule/src/core/Pan.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../third_parties/dawmodule/src/core/WavWriter.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../third_parties/dawmodule/src/core/ClipPlayer.cpp
)

# Automatically find all subdirectories in src/functions and src/core to add to include path
file(GLOB FUNCTION_SUBDIRS "src/functions/*")
list(APPEND FUNCTION_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/src/core")
foreach(dir ${FUNCTION_SUBDIRS})
  if(IS_DIRECTORY ${dir})
    list(APPEND FUNCTION_INCLUDE_DIRS ${dir})
  endif()
endforeach()

qt_add_qml_module(mokmEditor
    URI mokmME
    QML_FILES
        src/pages/Main.qml
        src/pages/Theme.qml
        src/pages/SplashScreen.qml
        src/pages/ProjectSetup.qml
        src/pages/components/StyledButton.qml
        src/pages/components/StyledTextField.qml
        src/pages/components/StyledComboBox.qml
        src/pages/components/StyledPanel.qml
        src/pages/components/ProjectCard.qml
        src/pages/tabs/TimelineTab.qml
        src/pages/tabs/NodeEditorTab.qml
        src/pages/tabs/GraphEditorTab.qml
        src/pages/tabs/AudioEditorTab.qml
        src/pages/components/fragments/ThemedIcon.qml
        src/pages/components/fragments/KeyframeDiamond.qml
        src/pages/components/fragments/PropertyRow.qml
        src/pages/components/fragments/NumberSlider.qml
        src/pages/components/fragments/ColorField.qml
        src/pages/components/fragments/TrackTypeConfig.qml
        src/pages/components/fragments/AddTrackDialog.qml
        src/pages/components/timeline/TimelineLayerHeader.qml
        src/pages/components/timeline/TimelineTrackHeader.qml
        src/pages/components/PropertiesPanel.qml
        SOURCES ${FUNCTION_SOURCES} ${CORE_SOURCES} ${AUDIO_SOURCES}
        RESOURCES src/resources/resources.qrc
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(mokmEditor PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.mokmME
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(mokmEditor
    PRIVATE Qt6::Quick
            Qt6::QuickControls2
            Qt6::QuickEffects
            ${FFmpeg_LIBRARIES}
            ${PortAudio_LIBRARIES}
            thorvg
            dl
            pthread
)

if(FUNCTION_INCLUDE_DIRS)
  target_include_directories(mokmEditor PRIVATE ${FUNCTION_INCLUDE_DIRS})
endif()

target_include_directories(mokmEditor PRIVATE 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/providers
    ${FFmpeg_INCLUDE_DIRS}
    ${PortAudio_INCLUDE_DIRS}
    ${CMAKE_CURRENT_SOURCE_DIR}/../third_parties/thorvg/inc
    ${CMAKE_CURRENT_SOURCE_DIR}/../third_parties/dawmodule/src/core
)

install(TARGETS mokmEditor
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
