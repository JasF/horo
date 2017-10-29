//
//  settings.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "settings.h"
#include "json/writer.h"
#include "json/reader.h"

namespace horo {
  
    _Settings::_Settings(strong<Serializer> serializer)
    : serializer_(serializer) {
        SCParameterAssert(serializer_.get());
    }
    
    _Settings::~_Settings() {
        
    }
    
    strong<Person> _Settings::currentPerson() {
        strong<Person> person = new Person();
        Json::Value value = dictionaryWithKey("currentPerson");
        person->decode(value);
        if (!person->zodiac().get() || person->zodiac()->type() == Unknown) {
            return nullptr; // AV: Saved user not found
        }
        return person;
    }
    
    void _Settings::setCurrentPerson(strong<Person> person) {
        saveObject("currentPerson", person.get());
    }
    
// private methods
    void _Settings::saveObject(std::string key, Coding *encoder) {
        Json::Value value = valueWithEncoder(encoder);
        saveDictionary(key, value);
    }
    
    dictionary _Settings::dictionaryWithKey(std::string key) {
        std::string data = serializer_->loadString(key);
        Json::Reader reader;
        Json::Value result;
        if (!reader.parse(data, result)) {
            Json::Value empty;
            return empty;
        }
        return result;
    }
    
    void _Settings::saveDictionary(std::string key, dictionary dictionary) {
        Json::StyledWriter writer;
        std::string data = writer.write(dictionary);
        serializer_->saveString(key, data);
    }
    
    Json::Value _Settings::valueWithEncoder(Coding *encoder) {
        SCAssert(encoder, "encoder is nil!");
        Json::Value root;
        if (!encoder) {
            return root;
        }
        encoder->encode(root);
        return root;
    }
};
