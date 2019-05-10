#include "CodeViewModel.h"

CodeViewModel::CodeViewModel() {
}

QString CodeViewModel::name() const {
    return m_name;
}

QString CodeViewModel::description() const {
    return m_description;
}

QString CodeViewModel::code() const {
    return m_code;
}

QString CodeViewModel::barcodeType() const {
    return m_type;
}

void CodeViewModel::update(CodeViewModel *other) {
    m_name = other->name();
    m_description = other->description();
    m_code = other->code();
    m_type = other->barcodeType();

    emit nameChanged(m_name);
    emit descriptionChanged(m_description);
    emit codeChanged(m_code);
    emit barcodeTypeChanged(m_code);
}

CodeViewModel *CodeViewModel::clone() {
    CodeViewModel* clone = new CodeViewModel();
    clone->setName(m_name);
    clone->setDescription(m_description);
    clone->setCode(m_code);
    clone->setBarcodeType(m_type);

    return clone;
}

void CodeViewModel::setName(QString arg) {
    if (m_name != arg) {
        m_name = arg;
        emit nameChanged(arg);
    }
}

void CodeViewModel::setDescription(QString arg) {
    if (m_description != arg) {
        m_description = arg;
        emit descriptionChanged(arg);
    }
}

void CodeViewModel::setCode(QString arg) {
    if (m_code != arg) {
        m_code = arg;
        emit codeChanged(arg);
    }
}

void CodeViewModel::setBarcodeType(QString arg) {
    if (m_type != arg) {
        m_type = arg;
        emit barcodeTypeChanged(arg);
    }
}

QString CodeViewModel::generateCode(QString code, QString barcodeType) {
    QString encoded;
    QString barcode;

    if ( barcodeType == "0" ) {  // code 128
        encoded.prepend(QChar(codeToChar(CODE128_B_START)));  // Start set with B Code 104
        encoded.append(code);
        encoded.append(QChar(calculateCheckCharacter(code)));
        encoded.append(QChar(codeToChar(CODE128_STOP)));  // End set with Stop Code 106
    }

    if ( barcodeType == "1" ) { // EAN 8
        /* It resembles EAN 13 very much.
           It has 7 digits and a checksum computed exactly in the same way as for code EAN13.
           The delimiters left (We shall use ASCII 58), middle and right are the same ones.
           The first 4 digits are build with table A and the last 4 ones with the table C.'
           Parameters : a 7 digits length string
           Return : * a string which give the bar code when it is dispayed with EAN13.TTF font
        */
        int i;
        if (code.count() == 7) {
            int checksum = 0;
            // no 8th (checksum) number entered
            for ( i = 6; i >= 0; i-=2 ) {
                checksum = checksum + code.mid(i, 1).toInt();
            }
            checksum = checksum * 3;
            for ( i = 5; i >= 0; i-=2 ) {
                checksum = checksum + code.mid(i, 1).toInt();
            }
            code = code.append(QString::number((10 - checksum % 10) % 10));
        }
        barcode = ":";  // Add start mark
        for ( i = 0; i < 4; i+=1 ) {
            barcode = barcode + static_cast<char>(65 + code.mid(i, 1).toInt());
        }
        barcode = barcode + "*";  // Add middle separator
        for ( i = 4; i < 8; i+=1 ) {
            barcode = barcode + static_cast<char>(97 + code.mid(i, 1).toInt());
        }
        barcode = barcode + "+";  // Add end mark
        // QTextStream(stdout) << "barcode = " << barcode;
        encoded = barcode;
    }

    if ( barcodeType == "2" ) {  // EAN 13
        int i;
        if (code.count() == 12) {
            int checksum = 0;
            // no 13th (checksum) number entered
            for ( i = 11; i >= 0; i-=2 ) {
                checksum = checksum + code.mid(i, 1).toInt();
            }
            checksum = checksum * 3;
            for ( i = 10; i >= 0; i-=2 ) {
                checksum = checksum + code.mid(i, 1).toInt();
            }
            code = code.append(QString::number((10 - checksum % 10) % 10));
        }
        // The first digit is taken just as it is, the second one comes from table A
        barcode = code.at(0) + static_cast<char>(65 + code.mid(1, 1).toInt());
        int first = code.mid(0, 1).toInt();
        bool tableA;
        for ( i = 2; i < 7; i+=1 ) {
            tableA = false;
            switch (i) {
                case 2:
                    switch (first) {
                        case 0: tableA = true; break;
                        case 1: tableA = true; break;
                        case 2: tableA = true; break;
                        case 3: tableA = true; break;
                    }
                    break;
                case 3:
                    switch (first) {
                        case 0: tableA = true; break;
                        case 4: tableA = true; break;
                        case 7: tableA = true; break;
                        case 8: tableA = true; break;
                    }
                    break;
                case 4:
                    switch (first) {
                        case 0: tableA = true; break;
                        case 1: tableA = true; break;
                        case 4: tableA = true; break;
                        case 5: tableA = true; break;
                        case 9: tableA = true; break;
                    }
                    break;
                case 5:
                    switch (first) {
                        case 0: tableA = true; break;
                        case 2: tableA = true; break;
                        case 5: tableA = true; break;
                        case 6: tableA = true; break;
                        case 7: tableA = true; break;
                    }
                    break;
                case 6:
                    switch (first) {
                        case 0: tableA = true; break;
                        case 3: tableA = true; break;
                        case 6: tableA = true; break;
                        case 8: tableA = true; break;
                        case 9: tableA = true; break;
                    }
                    break;
            }
            if (tableA) {
                barcode = barcode + static_cast<char>(65 + code.mid(i, 1).toInt());
            } else {
                barcode = barcode + static_cast<char>(75 + code.mid(i, 1).toInt());
            }
        }
        barcode = barcode + "*";  // Add middle separator
        for ( i = 7; i < 13; i+=1 ) {
            barcode = barcode + static_cast<char>(97 + code.mid(i, 1).toInt());
        }
        barcode = barcode + "+";  // Add end mark
        /* QTextStream(stdout) << "barcode = " << barcode; */
        encoded = barcode;
    }
    if ( barcodeType == "3" ) {  // Code 39
        barcode = "*";  // Add start mark
        barcode = barcode + code;
        barcode = barcode + "*";  // Add end mark
        encoded = barcode;
    }
    if ( barcodeType == "4" ) {  // Code 93
        barcode = barcode + static_cast<char>(144);  // Add start/end mark
        /* barcode = barcode + '-'; */
        int weight = code.length();
        int weighted_sum = 0;
        int i, checkum_loop, v_ascii;
        QChar c;
        for ( checkum_loop = 0; checkum_loop < 2; checkum_loop+=1 ) {
            for ( i = 0; i < code.length(); i+=1 ) {
                c = code.at(i);
                if (c.digitValue() != -1) {
                    v_ascii = c.digitValue();
                } else {
                    if (c == '-') {
                        v_ascii = 36;
                    } else if (c == '.') {
                        v_ascii = 37;
                    } else if (c == ' ') {
                        v_ascii = 38;
                    } else if (c == '$') {
                        v_ascii = 39;
                    } else if (c == '/') {
                        v_ascii = 40;
                    } else if (c == '+') {
                        v_ascii = 41;
                    } else if (c == '%') {
                        v_ascii = 42;
                    } else {
                        v_ascii = c.toLatin1() - 55;
                    }
                }
                weighted_sum = weighted_sum + (weight * (v_ascii));
                /* QTextStream(stdout) << "char_code: " << v_ascii; */
                /* QTextStream(stdout) << "weighted_sum tussenstand: " << weighted_sum; */
                weight = weight - 1;
            }
            /* QTextStream(stdout) << "weighted_sum = " << weighted_sum; */
            switch (weighted_sum % 47) {
                case  0: code = code + "0"; break;
                case  1: code = code + "1"; break;
                case  2: code = code + "2"; break;
                case  3: code = code + "3"; break;
                case  4: code = code + "4"; break;
                case  5: code = code + "5"; break;
                case  6: code = code + "6"; break;
                case  7: code = code + "7"; break;
                case  8: code = code + "8"; break;
                case  9: code = code + "9"; break;
                case 36: code = code + "-"; break;
                case 39: code = code + "$"; break;
                case 40: code = code + "/"; break;
                case 41: code = code + "+"; break;
                case 42: code = code + "%"; break;
                default: code = code + static_cast<char>((weighted_sum % 47) + 55); break;
            }
            weight = code.length();
            weighted_sum = 0;
        }
        barcode = barcode + code.replace(" ", "ß");
        barcode = barcode + static_cast<char>(144);  // Add start/end mark
        barcode = barcode + static_cast<char>(252);  // Terminate code
        /* QTextStream(stdout) << "barcode: " << barcode; */
        encoded = barcode;
    }
    if ( barcodeType == "5" ) {  // UPC-E
        // leading number
        int system_encode = code.at(0).digitValue();
        if ( system_encode == 0 ) {
            barcode = "P";
        } else {
            barcode = "Q";  // 1 as second option
        }
        // 6 digits
        QChar c;
        int i;
        QString OddEven;
        int code_nbr = code.at(7).digitValue();
        for ( i = 0; i < 10; i+=1 ) {
            switch (code_nbr) {
                case 0: OddEven = "EEEOOO"; break;
                case 1: OddEven = "EEOEOO"; break;
                case 2: OddEven = "EEOOEO"; break;
                case 3: OddEven = "EEOOOE"; break;
                case 4: OddEven = "EOEEOO"; break;
                case 5: OddEven = "EOOEEO"; break;
                case 6: OddEven = "EOOOEE"; break;
                case 7: OddEven = "EOEOEO"; break;
                case 8: OddEven = "EOEOOE"; break;
                case 9: OddEven = "EOOEOE"; break;
            }
        }
        if ( system_encode == 1 ) {
            // invert even/odd
            OddEven = OddEven.replace('E', 'o').replace('O', 'e');
            OddEven = OddEven.toUpper();
        }
        for ( i = 1; i < 7; i+=1 ) {
            if ( OddEven.at(i-1).toLatin1() == 'E' ) {
                barcode = barcode + static_cast<char>(16 + code.at(i).toLatin1());
            } else {
                barcode = barcode + code.at(i).toLatin1();
            }
        }
        // trailing number
        switch (code_nbr) {
            case  0: barcode = barcode + "`"; break;
            case  1: barcode = barcode + "a"; break;
            case  2: barcode = barcode + "b"; break;
            case  3: barcode = barcode + "c"; break;
            case  4: barcode = barcode + "d"; break;
            case  5: barcode = barcode + "e"; break;
            case  6: barcode = barcode + "f"; break;
            case  7: barcode = barcode + "g"; break;
            case  8: barcode = barcode + "h"; break;
            case  9: barcode = barcode + "i"; break;
        }
        encoded = barcode;
    }
    if ( barcodeType == "6" ) {  // UPC-A
        // 12 digits
        // leading number
        barcode = barcode + static_cast<char>(32 + code.at(0).toLatin1());
        // next 5
        int i;
        for ( i = 1; i < 6; i+=1 ) {
            barcode = barcode + code.at(i);
        }
        // separator
        barcode = barcode + "p";
        // next 5
        for ( i = 6; i < 11; i+=1 ) {
            barcode = barcode + static_cast<char>(16 + code.at(i).toLatin1());
        }
        // trailing number
        barcode = barcode + static_cast<char>(48 + code.at(11).toLatin1());
        encoded = barcode;
    }
    if ( barcodeType == "8" ) {  // KIX
        encoded = code;
    }
    return encoded;
}

int CodeViewModel::codeToChar(int code) {
    return code + 105;
}

int CodeViewModel::charToCode(int ch) {
    return ch - 32;
}

int CodeViewModel::calculateCheckCharacter(QString code) {
    QByteArray encapBarcode(code.toUtf8());  // Convert code to utf8

    //Calculate check character
    long long sum = CODE128_B_START; //The sum starts with the B Code start character value
    int weight = 1; //Initial weight is 1

    foreach(char ch, encapBarcode) {
        int code_char = charToCode((int)ch);  // Calculate character code
        sum += code_char*weight;  // add weighted code to sum
        weight++;  // increment weight
    }

    int remain = sum%103;  // The check character is the modulo 103 of the sum

    // Calculate the font integer from the code integer
    if (remain >= 95)
        remain += 105;
    else
        remain += 32;

    return remain;
}

QDataStream &operator <<(QDataStream &stream, const CodeViewModel &code) {
    stream << code.m_name;
    stream << code.m_description;
    stream << code.m_code;
    stream << code.m_type;

    return stream;
}

QDataStream &operator >>(QDataStream &stream, CodeViewModel &code) {
    stream >> code.m_name;
    stream >> code.m_description;
    stream >> code.m_code;
    stream >> code.m_type;

    return stream;
}
