#include "CodeViewModel.h"
#include "MainViewModel.h"

#include <QFile>
#include <QDir>
#include <QtQml>

MainViewModel::MainViewModel()
{
    load();
}

QList<QObject *> MainViewModel::codes() const
{
    return m_codes;
}

void MainViewModel::setCodes(QList<QObject *> arg)
{
    if (m_codes != arg) {
        m_codes = arg;
        emit codesChanged(arg);
    }
}

void MainViewModel::createCode(CodeViewModel* code)
{
    m_codes << code;

    emit codesChanged(m_codes);

    save();
}

void MainViewModel::removeCode(CodeViewModel *code)
{
    m_codes.removeAll(code);

    emit codesChanged(m_codes);

    save();
}

void MainViewModel::load()
{
    QDir dir;
    QFile file((dir.homePath() + "/.local/share/harbour-clubcode/database"));

    if (file.open(QIODevice::ReadOnly))
    {
        QDataStream stream(&file);

        while (!stream.atEnd())
        {
            CodeViewModel* item = new CodeViewModel();
            stream >> *item;

            m_codes << item;
        }
        for (int i=0; i< m_codes.count(); i++) {
            for (int j=0; j < i; j++) {
                if (m_codes.at(i)->property("name") <= m_codes.at(j)->property("name")) {
                    m_codes.move(i, j);
                }
            }
        }
    }
}

void MainViewModel::save()
{
    QDir dir;
    QDir::current().mkpath(dir.homePath() + "/.local/share/harbour-clubcode");

    QFile file((dir.homePath() + "/.local/share/harbour-clubcode/database"));

    if (file.open(QIODevice::WriteOnly))
    {
        QDataStream stream(&file);

        foreach (QObject*item, m_codes)
        {
            stream << *(CodeViewModel*)item;
        }
    }
}
