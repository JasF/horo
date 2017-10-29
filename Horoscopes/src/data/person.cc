//
//  person.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "person.h"

namespace horo {
    
    static const char *kName = "kName";
    static const char *kZodiacType = "kZodiacType";
    static const char *kGender = "kGender";
  
    _Person::_Person() {
        
    }
    _Person::_Person(strong<Zodiac> zodiac, std::string name, Gender gender)
    : zodiac_(zodiac)
    , name_(name)
    , gender_(gender) {
        SCParameterAssert(zodiac_);
        SCParameterAssert(name_.length());
        SCParameterAssert(gender_);
    }
    
    _Person::~_Person() {
        
    }
    
    void _Person::encode(Json::Value &coder) {
        coder[kZodiacType] = zodiac_->type();
        coder[kName] = name_;
        coder[kGender] = gender_;
    }
    
    void _Person::decode(Json::Value &coder) {
        ZodiacTypes type = (ZodiacTypes)coder[kZodiacType].asInt();
        if (type != Unknown) {
            zodiac_ = new Zodiac(type);
        }
        else {
            zodiac_ = nullptr;
        }
        name_ = coder[kName].asString();
        gender_ = (Gender) coder[kGender].asInt();
    }
    
};
