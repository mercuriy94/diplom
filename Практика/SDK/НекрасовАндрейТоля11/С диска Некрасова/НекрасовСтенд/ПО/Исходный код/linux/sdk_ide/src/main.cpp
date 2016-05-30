#include <QApplication>
#include "mainwindow.cpp"
int main(int argc, char** argv){
	QApplication app(argc, argv);
	mainwindow win;
	QObject::connect(win.action_quit, SIGNAL(triggered()),&app,SLOT(closeAllWindows()));
//	QObject::connect(&win, SIGNAL(signal_view_position(QString)),win.status_bar,SLOT(showMessage(const QString&)));
	win.show();
	return app.exec();
}
