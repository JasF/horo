//
//  persondaoimpl.c
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "persondaoimpl.h"
#include "data/url.h"

static const char * kPersonsSQLCreate = ""\
"CREATE TABLE IF NOT EXISTS persons ("\
"id INTEGER PRIMARY KEY AUTOINCREMENT, "\
"name TEXT, "\
"imageUrl TEXT, "\
"personUrl TEXT, "\
"zodiacType INTEGER, "\
"gender INTEGER, "\
"status INTEGER, "\
"type INTEGER, "\
"birthdayDate STRING, "\
"withFacebook INTEGER, "\
"uniqueIdentifier STRING"\
");";

static const char * kPersonsSQLSelect = ""\
"SELECT "\
"id "\
"FROM "\
"persons "\
"WHERE uniqueIdentifier = :uniqueIdentifier;";

static const char * kPersonsSQLSelectById = ""\
"SELECT "\
"* "\
"FROM "\
"persons "\
"WHERE id = :id;";


static const char * kPersonsSQLReadFacebookFriends = ""\
"SELECT "\
"* "\
"FROM "\
"persons "\
"WHERE withFacebook != 0 AND type = 2 "
"ORDER BY name;"; // type=2 means friend (1==user, 0==unknown)

static const char * kPersonsSQLUpdate = ""\
"UPDATE "\
"persons "\
"SET "\
"name = :name, "\
"imageUrl = :imageUrl, "\
"personUrl = :personUrl, "\
"zodiacType = :zodiacType, "\
"gender = :gender, "\
"status = :status, "\
"type = :type, "\
"birthdayDate = :birthdayDate, "\
"withFacebook = :withFacebook, "\
"uniqueIdentifier = :uniqueIdentifier "\
"WHERE "\
"id = :id;";

static const char * kPersonsSQLInsert = ""\
"INSERT INTO "\
"persons ("\
"name, "\
"imageUrl, "\
"personUrl, "\
"zodiacType, "\
"gender, "\
"status, "\
"type, "\
"birthdayDate, "\
"withFacebook, "\
"uniqueIdentifier"\
") "\
"VALUES "\
"("\
":name, "\
":imageUrl, "\
":personUrl, "\
":zodiacType, "\
":gender, "\
":status, "\
":type, "\
":birthdayDate, "\
":withFacebook, "\
":uniqueIdentifier"\
");";

namespace horo {
  
    bool PersonDAOImpl::writePerson(strong<Person> person) {
        if (!person.get()) {
            return false;
        }
        // за id у нас считается path() от personUrl
        string uniqueIdentifier = person->uniqueIdentifier();
        
        Json::Value value = person->encoded();
        LOG(LS_WARNING) << "value: " << value.toStyledString();
        strong<ResultSet> resultSet = database_->executeQuery(kPersonsSQLSelect, value);
        if (resultSet.get() && resultSet->next()) {
            int rowid = resultSet->intForColumn("id");
            return update(person, rowid);
        }
        bool result = database_->executeUpdate(kPersonsSQLInsert, value);
        return result;
    }
    
    set<strong<Person>> PersonDAOImpl::readFacebookFriends() {
        set<strong<Person>> result;
        strong<ResultSet> resultSet = database_->executeQuery(kPersonsSQLReadFacebookFriends);
        while (resultSet.get() && resultSet->next()) {
            strong<Person> fbFriend = resultSetToJsonValue<Person>(resultSet);
            result.insert(fbFriend);
        }
        return result;
    }
    
    void PersonDAOImpl::create() {
        bool result = database_->executeUpdate(kPersonsSQLCreate);
        LOG(LS_INFO) << "creation persons result is: " << result;
    }
    
    bool PersonDAOImpl::update(strong<Person> person, int rowid) {
        if (!person.get() || !rowid) {
            return false;
        }
        Json::Value parameters = person->encoded();
        parameters["id"] = rowid;
        
        Json::Value idParameter;
        idParameter["id"] = rowid;
        strong<ResultSet> resultSet = database_->executeQuery(kPersonsSQLSelectById, idParameter);
        if (resultSet.get() && resultSet->next()) {
            strong<Person> fbFriend = resultSetToJsonValue<Person>(resultSet);
            if (fbFriend->status() == StatusCompleted ||
                fbFriend->status() == StatusFailed) {
                return false;
            }
        }
        
        bool result = database_->executeUpdate(kPersonsSQLUpdate, parameters);
        return result;
    }
};
