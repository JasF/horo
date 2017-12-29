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

static int const kPushTimeDefaultValue = 11;

namespace horo {
  
    _Settings::_Settings(strong<Serializer> serializer)
    : serializer_(serializer) {
        SCParameterAssert(serializer_.get());
        if (!readInt("initialized")) {
            initializeDefaults();
            saveInt("initialized", 1);
        }
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
    
    int _Settings::pushTime() {
        return readInt("pushTime");
    }
    
    void _Settings::setPushTime(int pushTime) {
        saveInt("pushTime", pushTime);
    }
    
    bool _Settings::notificationsDisabled() {
        return readBool("notificationsDisabled");
    }
    
    void _Settings::setNotificationsDisabled(bool disabled) {
        saveBool("notificationsDisabled", disabled);
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
    
    void _Settings::saveInt(string key, int value) {
        Json::Value dictionary;
        dictionary[key] = value;
        saveDictionary(key, dictionary);
    }
    
    int _Settings::readInt(string key) {
        Json::Value dictionary = dictionaryWithKey(key);
        int result = dictionary[key].asInt();
        return result;
    }
    
    void _Settings::saveBool(string key, bool value) {
        Json::Value dictionary;
        dictionary[key] = value;
        saveDictionary(key, dictionary);
    }
    
    bool _Settings::readBool(string key) {
        Json::Value dictionary = dictionaryWithKey(key);
        bool result = dictionary[key].asInt();
        return result;
    }
    
    void _Settings::initializeDefaults() {
        setPushTime(kPushTimeDefaultValue);
    }
    
};
