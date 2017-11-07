//
//  persondao.h
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef persondao_h
#define persondao_h

#include "base/horobase.h"
#include "data/person.h"

namespace horo {
    class _PersonDAO {
    public:
        ~_PersonDAO() {}
    public:
        virtual bool writePerson(strong<Person> person)=0;
        virtual set<strong<Person>> readFacebookFriends()=0;
        virtual void create()=0;
    };
    
    typedef reff<_PersonDAO> PersonDAO;
};

#endif /* persondao_h */
