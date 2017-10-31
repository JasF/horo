//
//  horoscopedaoimpl.c
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "horoscopedaoimpl.h"

static const char * kSQLCreate = ""\
"CREATE TABLE IF NOT EXISTS horoscopes ("\
"id INTEGER PRIMARY KEY AUTOINCREMENT, "\
"zodiac INTEGER, "\
"type INTEGER, "\
"date INTEGER, "\
"content TEXT"\
");";

/** Query for the inssert row. */
static const char * kSQLInsert = ""\
"INSERT INTO "\
"horoscopes (zodiac, type, date, content) "\
"VALUES "\
"(:zodiac, :type, :date, :content);";

namespace horo {
    
bool HoroscopeDAOImpl::writeHoroscope(strong<HoroscopeDTO> horoscope) {
    Json::Value parameters;
    horoscope->encode(parameters);
    bool result = database_->executeUpdate(kSQLCreate, parameters);
    return result;
}

strong<HoroscopeDTO> HoroscopeDAOImpl::readHoroscope(uint64_t date, HoroscopeType type) {
    return nullptr;
}
    
void HoroscopeDAOImpl::create() {
    database_->executeUpdate(kSQLCreate);
}

};
