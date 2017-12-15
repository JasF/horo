//
//  person.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "person.h"
#include "data/url.h"

namespace horo {
    
    static const char *kName = "name";
    static const char *kImageUrl = "imageUrl";
    static const char *kPersonUrl = "personUrl";
    static const char *kZodiacType = "zodiacType";
    static const char *kGender = "gender";
    static const char *kStatus = "status";
    static const char *kType = "type";
    static const char *kBirthdayDate = "birthdayDate";
    static const char *kWithFacebook = "withFacebook";
    static const char *kUniqueIdentifier = "uniqueIdentifier";
  
    _Person::_Person() : gender_(GenderUnknown),
        status_(StatusUnknown),
        type_(TypeUnknown),
        withFacebook_(false),
        updating_(false),
        wrapper_(nullptr)
    {}
    
    _Person::_Person(strong<Zodiac> zodiac,
                     std::string name,
                     std::string imageUrl,
                     std::string personUrl,
                     Gender gender,
                     PersonStatus status,
                     PersonType type,
                     DateWrapper birthdayDate,
                     bool withFacebook)
    : zodiac_(zodiac),
    name_(name),
    imageUrl_(imageUrl),
    personUrl_(personUrl),
    gender_(gender),
    status_(status),
    type_(type),
    birthdayDate_(birthdayDate),
    withFacebook_(withFacebook),
    updating_(false),
    wrapper_(nullptr) {
        if (type_ == TypeFriend) {
            SCParameterAssert(personUrl_.length());
        }
        else if (type_ == TypeUser) {
            SCParameterAssert(birthdayDate_.toString().length());
        }
    }
    
    _Person::~_Person() {
        
    }
    
    void _Person::encode(Json::Value &coder) {
        coder[kZodiacType] = (zodiac_.get()) ? zodiac_->type() : Unknown;
        coder[kName] = name_;//string
        coder[kImageUrl] = imageUrl_;
        coder[kPersonUrl] = personUrl_;
        coder[kGender] = gender_;//int
        coder[kStatus] = status_;
        coder[kType] = type_;
        coder[kBirthdayDate] = birthdayDate_.toString();
        coder[kWithFacebook] = withFacebook_;
        coder[kUniqueIdentifier] = uniqueIdentifier();
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
        imageUrl_ = coder[kImageUrl].asString();
        personUrl_ = coder[kPersonUrl].asString();
        gender_ = (Gender) coder[kGender].asInt();
        status_ = (PersonStatus) coder[kStatus].asInt();
        type_ = (PersonType) coder[kType].asInt();
        birthdayDate_ = DateWrapper(coder[kBirthdayDate].asString());
        withFacebook_ = (bool) coder[kWithFacebook].asBool();
    }
    
    string _Person::uniqueIdentifier() {
        if (!personUrl_.length()) {
            return "0";
        }
        Url url(personUrl_);
        if (url.path() == "profile.php") {
            return personUrl_;
        }
        return url.path();
    }
};
