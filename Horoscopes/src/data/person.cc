//
//  person.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "person.h"

namespace horo {
    
    static const char *kName = "name";
    static const char *kZodiacType = "zodiacType";
    static const char *kGender = "gender";
    static const char *kStatus = "status";
    static const char *kType = "type";
    static const char *kBirthdayDate = "birthdayDate";
    static const char *kWithFacebook = "withFacebook";
  
    _Person::_Person() : gender_(GenderUnknown),
        status_(StatusUnknown),
        type_(TypeUnknown),
        withFacebook_(false)
    {}
    
    _Person::_Person(strong<Zodiac> zodiac,
                     std::string name,
                     Gender gender,
                     PersonStatus status,
                     PersonType type,
                     DateWrapper birthdayDate,
                     bool withFacebook)
    : zodiac_(zodiac),
    name_(name),
    gender_(gender),
    status_(status),
    type_(type),
    birthdayDate_(birthdayDate),
    withFacebook_(withFacebook) {
        SCParameterAssert(zodiac_);
        SCParameterAssert(name_.length());
        SCParameterAssert(gender_);
        SCParameterAssert(status_);
        SCParameterAssert(type_);
    }
    
    _Person::~_Person() {
        
    }
    
    void _Person::encode(Json::Value &coder) {
        coder[kZodiacType] = zodiac_->type();//int
        coder[kName] = name_;//string
        coder[kGender] = gender_;//int
        coder[kStatus] = status_;
        coder[kType] = type_;
        coder[kBirthdayDate] = birthdayDate_.toString();
        coder[kWithFacebook] = withFacebook_;
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
        status_ = (PersonStatus) coder[kStatus].asInt();
        type_ = (PersonType) coder[kType].asInt();
        birthdayDate_ = DateWrapper(coder[kBirthdayDate].asString());
        withFacebook_ = (bool) coder[kWithFacebook].asBool();
    }
    
};
