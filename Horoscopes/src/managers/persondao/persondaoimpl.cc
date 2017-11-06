//
//  persondaoimpl.c
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "persondaoimpl.h"

static const char * kSQLCreate = ""\
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
"withFacebook INTEGER,"\
");";

namespace horo {
  
    bool PersonDAOImpl::writePerson(strong<Person> person) {
        return false;
    }
    
    list<Person> PersonDAOImpl::readPersons() {
        list<Person> result;
        
        return result;
    }
    
    void PersonDAOImpl::create() {
        database_->executeUpdate(kSQLCreate);
    }
    
};
