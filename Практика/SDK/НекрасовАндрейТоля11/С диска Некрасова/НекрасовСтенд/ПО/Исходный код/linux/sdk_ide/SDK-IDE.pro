TEMPLATE = app
QT = gui core
CONFIG += qt \
 warn_on \
 console \
 build_all \
 debug_and_release
DESTDIR = bin
OBJECTS_DIR = build
MOC_DIR = build
UI_DIR = build
SOURCES = src/main.cpp src/mainwindow.cpp src/editor.cpp
HEADERS += src/mainwindow.h src/editor.h
RESOURCES += images.qrc
