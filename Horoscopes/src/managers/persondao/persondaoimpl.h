//
//  persondaoimpl.h
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef persondaoimpl_h
#define persondaoimpl_h

#include "persondao.h"
#include "database/database.h"

namespace horo {
    
    class PersonDAOImpl : public PersonDAO {
    public:
        PersonDAOImpl(strong<Database> database) : database_(database) {
            SCParameterAssert(database_);
        }
        virtual ~PersonDAOImpl() override {}
    public:
        bool writePerson(strong<Person> person) override;
        list<Person> readPersons() override;
        void create() override;
    private:
        strong<Database> database_;
    };
    
};

#endif /* persondaoimpl_h */
