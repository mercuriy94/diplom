#include "mainwindow.h"
#include "editor.h"
#include <QtGui>

mainwindow::mainwindow(QWidget* pwgt):QMainWindow(pwgt){

  QAction *action_new = new QAction("New File",0);
  action_new->setText("&New");
  action_new->setShortcut(QKeySequence("CTRL+N"));
  action_new->setToolTip("New Document");
  action_new->setStatusTip("Create a new file");
  action_new->setWhatsThis("Create a new file:");
  action_new->setIcon(QPixmap(":/filenew.png"));
  
  QAction *action_open = new QAction("Open File", 0);
  action_open->setText("&Open...");
  action_open->setShortcut(QKeySequence("CTRL+O"));
  action_open->setToolTip("Open Document");
  action_open->setStatusTip("Open an existing file");
  action_open->setWhatsThis("Open an existing file");
  action_open->setIcon(QPixmap(":/fileopen.png"));
  
  QAction *action_save = new QAction("Save File", 0);
  action_save->setText("&Save");
  action_save->setShortcut(QKeySequence("CTRL+S"));
  action_save->setToolTip("Save Document");
  action_save->setStatusTip("Save the file to disk");
  action_save->setWhatsThis("Save the file to disk");
  action_save->setIcon(QPixmap(":/filesave.png"));
  
  QAction *action_save_as = new QAction("Save File As...", 0);
  action_save_as->setText("Save &As...");
  action_save_as->setShortcut(QKeySequence("CTRL+A"));
  action_save_as->setToolTip("Save Document As...");
  action_save_as->setStatusTip("Save the file to disk with another name");
  action_save_as->setWhatsThis("Save the file to disk with another name");
  action_save_as->setIcon(QPixmap(":/filesaveas.png"));
  
  action_quit=new QAction("&Quit",0);
  action_quit->setShortcut(QKeySequence("CTRL+Q"));
  action_quit->setToolTip("Exit from programm");
  action_quit->setStatusTip("Exit from programm");
  action_quit->setWhatsThis("Exit from programm");
  action_quit->setIcon(QPixmap(":/exit.png"));
    
  QToolBar *tool_bar_file = new QToolBar("File Operations");
  tool_bar_file->addAction(action_new);
  tool_bar_file->addAction(action_open);
  tool_bar_file->addAction(action_save);
  tool_bar_file->addAction(action_save_as);
  addToolBar(Qt::TopToolBarArea, tool_bar_file);
  
  QAction  *action_compile=new QAction("Compile",0);
  action_compile->setShortcut(QKeySequence("CTRL+F5"));
  action_compile->setToolTip("Compile current file");
  action_compile->setStatusTip("Compile current file");
  action_compile->setWhatsThis("Compile current file");
  action_compile->setIcon(QPixmap(":/compile.png"));
  
	QAction  *action_load=new QAction("Load",0);
	action_load->setShortcut(QKeySequence("CTRL+F9"));
	action_load->setToolTip("Load hex file");
	action_load->setStatusTip("Load hex file");
	action_load->setWhatsThis("Load hex file");
	action_load->setIcon(QPixmap(":/load.png"));

	QToolBar *tool_bar_editor = new QToolBar("Editor Operations");
	tool_bar_editor->addAction(action_compile);
	tool_bar_editor->addAction(action_load);
	addToolBar(Qt::TopToolBarArea, tool_bar_editor);
	
	QStatusBar *status_bar = new QStatusBar();
	setStatusBar(status_bar);
	status_bar->showMessage("SDK-IDE");

	QMenu *menu_file = new QMenu("&File",this);
	menu_file->addAction(action_new); 
	menu_file->addAction(action_open); 
	menu_file->addAction(action_save);
	menu_file->addAction(action_save_as);
	menu_file->addSeparator();
	menu_file->addAction(action_quit);
	menuBar()->addMenu(menu_file);
	
	QMenu *menu_help = new QMenu("&Help",this);
	menuBar()->addMenu(menu_help);
  
	tab_widget=new QTabWidget(this);
	tab_widget->setTabsClosable(1); 
	driverTree = new QTreeWidget(this);
	driverTree->setColumnCount(1);
	driverTree->setHeaderLabel("Drivers:");
	
	label = new QLabel("Start adrr: 0x", this);

	lineEdit = new QLineEdit("0000",this);
	lineEdit->setInputMask("HHHH");
	lineEdit->setFixedWidth(30);
	
	QHBoxLayout *hStart = new QHBoxLayout;
	hStart->addWidget(label);
	hStart->addWidget(lineEdit);
	hStart->addStretch();

	
	QSplitter *splitter = new QSplitter(Qt::Horizontal);
	splitter->addWidget(tab_widget);
	splitter->addWidget(driverTree);
	splitter->setCollapsible(0,false);
	splitter->setCollapsible(1,false);
	
	QVBoxLayout *vLayout = new QVBoxLayout;
	vLayout->addWidget(splitter);
	vLayout->addLayout(hStart);
	
	
	QWidget *centralWidget = new QWidget;
	centralWidget->setLayout(vLayout);
	setCentralWidget(centralWidget);

	resize(640, 480);
	driverTree->setMaximumWidth(130);  
	//Заполнить driverTree списком драйверов
	QString pathDrv = "sys";
	QDir dir(pathDrv);
	QStringList filter("*.asm");
	QString fileNameDrv;
	foreach(QString file, dir.entryList(filter, QDir::Files)){
		fileNameDrv = QFileInfo(dir, file).fileName();
		itemTree_ = new QTreeWidgetItem(driverTree);
		itemTree_->setText(0, fileNameDrv);
		driverTree->addTopLevelItem(itemTree_);
	};
	connect(action_open, SIGNAL(triggered()),SLOT(slot_open()));
	connect(action_save, SIGNAL(triggered()),SLOT(slot_save()));
	connect(action_new, SIGNAL(triggered()),SLOT(slot_new()));
	connect(action_save_as, SIGNAL(triggered()),SLOT(slot_save_as()));
	connect(tab_widget, SIGNAL(tabCloseRequested(int)), SLOT(closeTab(int)));
	connect(action_compile, SIGNAL(triggered()),SLOT(slot_compile()));
	connect(action_load, SIGNAL(triggered()),SLOT(slot_load()));
	connect(this,SIGNAL(signal_view_position(QString)),status_bar,SLOT(showMessage(const QString&)));
	connect(driverTree, SIGNAL(itemDoubleClicked(QTreeWidgetItem*,int)),SLOT(openDriver(QTreeWidgetItem*,int)));
	connect(lineEdit, SIGNAL(textChanged(const QString&)), this , SLOT(saveCurrAddr(const QString&)));
	connect(tab_widget, SIGNAL(currentChanged(int)), this, SLOT(showAddr(int)));
}
void mainwindow::slot_open(){
  QString fullName = QFileDialog::getOpenFileName(this, "Open file", QDir::homePath(), "assembler (*.asm)");
    if (fullName.isEmpty()) return;
    QFile file(fullName);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
    	textEdit *text = new textEdit(tab_widget);
    	text->set_full_name(fullName);
    	text->start = "0000";
        QTextStream stream(&file);
        text->setPlainText(stream.readAll());
        file.close();
        text->resize(2000,20000);
        text->name=QFileInfo(file).fileName();
        tab_widget->addTab(text,text->name);
        tab_widget->setCurrentIndex((tab_widget->count())-1);
        connect(tab_widget->currentWidget(), SIGNAL(cursorPositionChanged()),SLOT(slot_cursor()));
        connect(tab_widget->currentWidget(), SIGNAL(textChanged()),SLOT(tabChanged()));
        
    }	
}
void mainwindow::openDriver(QTreeWidgetItem *itemDriver,int collumn){
	QString fullName = "sys/"+itemDriver->text(collumn);
	QFile file(fullName);
	if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
	textEdit *text = new textEdit(tab_widget);
	text->set_full_name(fullName);
	text->start = "0000";
	QTextStream stream(&file);
	text->setPlainText(stream.readAll());
	file.close();
	text->name=QFileInfo(file).fileName();
	text->resize(2000,20000);
  	tab_widget->addTab(text, text->name);
	tab_widget->setCurrentIndex((tab_widget->count())-1);
	connect(tab_widget->currentWidget(), SIGNAL(cursorPositionChanged()),SLOT(slot_cursor()));
	connect(tab_widget->currentWidget(), SIGNAL(textChanged()),SLOT(tabChanged()));
	
	}
}
void mainwindow::closeTab(int index){
	if (index==tab_widget->currentIndex()){
	if (tab_widget->currentWidget()->isWindowModified()){
		int r = QMessageBox::warning(this, "SDK-IDE",
		"The document has been modified.\n"
		"Do you want to save your changes?",
		QMessageBox::Save | QMessageBox::Discard | QMessageBox::Cancel);
		if (r == QMessageBox::Save) slot_save();
		else if (r == QMessageBox::Cancel) return; 
		else delete tab_widget->currentWidget();
		}
		else delete tab_widget->currentWidget();
	}
}
bool mainwindow::slot_save(){
	bool boo=false;
	if ((tab_widget->currentIndex())>=0){
		textEdit *text;
	    text = qobject_cast<textEdit*>(tab_widget->currentWidget());
	    if ((QDir::currentPath()+"/sys")==QFileInfo(text->fullName).absolutePath()){
	    	QMessageBox::warning(this, "SDK-IDE", "Save a file as...");
	    	if (slot_save_as()) return true;
	    	else return false;
    	};
		QFile file(text->fullName);
		if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
			QTextStream (&file) << text->toPlainText();
            file.close();
         if (tab_widget->currentWidget()->isWindowModified()) setTabModified(false);
         boo=true; 
		};
	return boo;	
	}
	return true;
}
void mainwindow::slot_new(){
	QString fullName = QFileDialog::getSaveFileName(this, "Save file as...", QDir::homePath(), "assembler (*.asm)"); 
	if (fullName.isEmpty()) {
        return;
    };
    if (QFileInfo(fullName).completeSuffix() != "asm")
    	fullName = QFileInfo(fullName).baseName()+".asm";
    textEdit *text = new textEdit(tab_widget);
    text->set_full_name(fullName);
    text->start = "0000";
    text->resize(2000,20000);
    text->name=QFileInfo(fullName).fileName();
    tab_widget->addTab(text,text->name);
    tab_widget->setCurrentIndex((tab_widget->count())-1); 
    connect(tab_widget->currentWidget(), SIGNAL(cursorPositionChanged()),SLOT(slot_cursor()));
    connect(tab_widget->currentWidget(), SIGNAL(textChanged()), SLOT(tabChanged()));
    
}
bool mainwindow::slot_save_as(void){
	bool boo=false;
	if ((tab_widget->currentIndex())>=0){
	QString fullName = QFileDialog::getSaveFileName(this, "Save file as...", QDir::homePath(), "assembler (*.asm)"); 
	if (fullName.isEmpty()) {
        return false;
    }
    textEdit *text;
	text = qobject_cast<textEdit*>(tab_widget->currentWidget());
    text->set_full_name(fullName);
    text->name=QFileInfo(fullName).fileName();
    tab_widget->setTabText(tab_widget->currentIndex(),text->name);
    if (tab_widget->currentWidget()->isWindowModified()) tab_widget->currentWidget()->setWindowModified(false); 
    slot_save();
    boo=true;
       };
    return boo;
}
void mainwindow::slot_compile(void){
	if ((tab_widget->currentIndex())>=0)
	{
		if (slot_save()==false) return;
		textEdit *text;
	    text = qobject_cast<textEdit*>(tab_widget->currentWidget());

    	QProcess *process;
    	process= new QProcess;
    	
		QStringList pm;
		pm<<"-quiet";		
		pm<<"-input";
		QDir home(QDir::homePath());
		QString s;
		s = home.relativeFilePath(text->fullName);
		QString s2;
		s2 = QDir::fromNativeSeparators(s);
		QString fullName2=text->fullName;
		fullName2.chop(3);//+"hex";
		fullName2+="hex";
		QStringList arg;
		arg<<QDir::toNativeSeparators(text->fullName)<<QDir::toNativeSeparators(fullName2);
		QString workPath = QDir::toNativeSeparators(QDir::currentPath()+"/sys/");
		process->startDetached(workPath+"tasm.bat", arg, workPath);
	}
}
	
	
	
void mainwindow::slot_cursor(void){
		textEdit *text;
		text = qobject_cast<textEdit*>(tab_widget->currentWidget());
		int line;
		line=text->textCursor().blockNumber();
       	emit signal_view_position("Current line is: "+QString::number(line+1));
	}
void mainwindow::slot_load(void){
	if ((tab_widget->currentIndex())>=0){
		textEdit *text;
	    text = qobject_cast<textEdit*>(tab_widget->currentWidget());
	    if ((text->start).size() != 4){
	    	QMessageBox::warning(this, "SDK-IDE", "Incorrect start address.");
	    	return;
    	}
    	QProcess *process;
    	process= new QProcess;
		QString fullName2=text->fullName;
		fullName2.chop(3);//+"hex";
		fullName2+="hex";
		if (QFileInfo(fullName2).exists()==false){
			QMessageBox::warning(this, "SDK-IDE", fullName2+"   doesn't exist.");
			return;
		}
		QStringList arg;
		arg<<QDir::toNativeSeparators(fullName2)<<text->start;
		QString workPath = QDir::toNativeSeparators(QDir::currentPath()+"/sys/");
		process->startDetached(workPath+"t167b.bat", arg, workPath);
	}
	
}
void mainwindow::setTabModified(bool swch){
	tab_widget->currentWidget()->setWindowModified(swch);
	int index = tab_widget->currentIndex();
	QString labe = tab_widget->tabText(index);
	if (swch) labe = "*"+labe;
	else labe.remove(0,1);
	tab_widget->setTabText(index, labe);
}
void mainwindow::tabChanged(){
	if (tab_widget->currentWidget()->isWindowModified()==false)
		setTabModified(true);
}
void mainwindow::saveCurrAddr(const QString& addr){
	if ((tab_widget->currentIndex())>=0){
	textEdit *text;
	text = qobject_cast<textEdit*>(tab_widget->currentWidget());
	text->setAddr(addr);
	}
}
void mainwindow::showAddr(int n){
	if (n>=0){
		textEdit *text;
		text = qobject_cast<textEdit*>(tab_widget->currentWidget());
		lineEdit->setText(text->start);
	}
}
