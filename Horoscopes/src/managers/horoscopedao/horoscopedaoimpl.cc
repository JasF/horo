//
//  horoscopedaoimpl.c
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "horoscopedaoimpl.h"
#include "database/resultset.h"

static const char * kSQLCreate = ""\
"CREATE TABLE IF NOT EXISTS horoscopes ("\
"id INTEGER PRIMARY KEY AUTOINCREMENT, "\
"zodiac INTEGER, "\
"type INTEGER, "\
"date INTEGER, "\
"content TEXT"\
");";

static const char * kSQLSelect = ""
"SELECT "
"id "
"FROM "
"horoscopes "
"WHERE type = :type AND date = :date;";
/** Query for the inssert row. */
static const char * kSQLInsert = ""\
"INSERT INTO "\
"horoscopes (zodiac, type, date, content) "\
"VALUES "\
"(:zodiac, :type, :date, :content);";

/** Query for the update row. */
static const char * kSQLUpdate = ""
"UPDATE "
"horoscopes "
"SET "
"type = :type, date = :date "
"WHERE "
"id = :id;";

static const char * kSQLSelectByDateType = ""
"SELECT "
"* "
"FROM "
"horoscopes "
"WHERE "
"date = :date AND type = :type;";

namespace horo {
    
bool HoroscopeDAOImpl::writeHoroscope(strong<HoroscopeDTO> horoscope) {
    if (!horoscope.get()) {
        return false;
    }
    Json::Value parameters;
    horoscope->encode(parameters);
    
    strong<ResultSet> results = database_->executeQuery(kSQLSelect, parameters);
    if (results->next()) {
        int rowid = results->intForColumn("id");
        Json::Value mutableParameters(parameters);
        mutableParameters["id"] = rowid;
        bool result = database_->executeUpdate(kSQLUpdate, mutableParameters);
        return result;
    }
    
    bool result = database_->executeUpdate(kSQLInsert, parameters);
    if (!result) {
        LOG(LS_WARNING) << "Insert error: " << database_->lastErrorMessage();
    }
    return result;
}

Json::Value resultSetToJsonValue(strong<ResultSet> resultSet) {
    Json::Value result;
    strong<HoroscopeDTO> temporary = new HoroscopeDTO();
    Json::Value keys;
    temporary->encode(keys);
    
    for( Json::ValueIterator it = keys.begin(); it != keys.end(); ++it )
    {
        std::string key = it.key().asString();
        Json::Value &value = *it;
        if (value.isUInt64()) {
            result[key] = resultSet->unsignedLongLongIntForColumn(key);
        }
        else if (value.isInt()) {
            result[key] = resultSet->intForColumn(key);
        }
        else if (value.isString()) {
            result[key] = resultSet->stringForColumn(key);
        }
        else {
            SCAssert(false, "Unhandled type for key");
        }
    }
    return result;
}
    
strong<HoroscopeDTO> HoroscopeDAOImpl::readHoroscope(uint64_t date, HoroscopeType type) {
    Json::Value parameters;
    parameters["date"] = date;
    parameters["type"] = type;
    strong<ResultSet> results = database_->executeQuery(kSQLSelectByDateType, parameters);
    if (results->next()) {
        Json::Value datasource = resultSetToJsonValue(results);
        strong<HoroscopeDTO> result = new HoroscopeDTO();
        result->decode(datasource);
        return result;
    }
    return nullptr;
}
    
void HoroscopeDAOImpl::create() {
    database_->executeUpdate(kSQLCreate);
}

};
