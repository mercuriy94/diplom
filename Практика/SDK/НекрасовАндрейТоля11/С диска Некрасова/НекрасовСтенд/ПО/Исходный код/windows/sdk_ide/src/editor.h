#ifndef EDITOR_H
#define EDITOR_H
#include <QString>
#include <QTextEdit>

class textEdit : public QTextEdit{
	Q_OBJECT
public:
  textEdit(QWidget* pwgt =0);
  QString fullName, name, start;
 
  void set_full_name(const QString& t){
  	fullName=t;
  }
  void set_name(const QString& t){
  	name=t;
  }

  void setAddr(const QString& t){
		start = t;
  }
};
#endif
