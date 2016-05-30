#ifndef _mainwindow_h_
#define _mainwindow_h_
#include <QMainWindow>

class QAction;
class QTreeWidget;
class QTreeWidgetItem;
class QTabWidget;
class QLineEdit;
class QLabel;

class mainwindow: public QMainWindow{
	Q_OBJECT
public:
	mainwindow(QWidget* parent=0);
	QAction *action_quit;//need
	QTreeWidget *driverTree;
	QTreeWidgetItem *itemTree_;
	QTabWidget *tab_widget;//need
	QLineEdit *lineEdit;
	QLabel *label;

protected:
public slots:
  void slot_open(void);
  void closeTab(int);
  bool slot_save(void);
  void slot_new(void);
  bool slot_save_as(void);
  void slot_compile(void);
  void slot_cursor(void);
  void slot_load(void);
  void openDriver(QTreeWidgetItem*,int);
  void setTabModified(bool);
  void tabChanged();
  void saveCurrAddr(const QString&);
  void showAddr(int);
  
signals:
  void signal_view_position(QString);
};
#endif
