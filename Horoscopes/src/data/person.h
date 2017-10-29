//
//  person.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef person_h
#define person_h

#include "base/horobase.h"
#include "zodiac.h"
#include "base/coding.h"

namespace horo {
    enum Gender {
        GenderUnknown,
        Male,
        Female
    };
    class _Person : public Coding {
    public:
        _Person();
        _Person(strong<Zodiac> zodiac, std::string name, Gender gender);
        virtual ~_Person();
    public:
        void encode(Json::Value &coder) override;
        void decode(Json::Value &coder) override;
        strong<Zodiac> zodiac() { return zodiac_; }
    private:
        strong<Zodiac> zodiac_;
        std::string name_; // utf-8
        Gender gender_;
    };
    
    typedef reff<_Person> Person;
    
};

#endif /* person_h */
