//
//  settings.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef settings_h
#define settings_h

#include <stdio.h>
#include "base/horobase.h"
#include "data/person.h"
#include "managers/serializer/serializer.h"

namespace horo {
  
    class _Settings {
    public:
        _Settings(strong<Serializer> serializer);
        virtual ~_Settings();
    public:
        strong<Person> currentPerson();
        void setCurrentPerson(strong<Person> person);
        int pushTime();
        void setPushTime(int pushTime);
        bool notificationsDisabled();
        void setNotificationsDisabled(bool disabled);
        
    private:
        void initializeDefaults();
        
    private:
        dictionary dictionaryWithKey(std::string key);
        void saveDictionary(std::string key, dictionary dictionary);
        Json::Value valueWithEncoder(Coding *encoder);
        void saveObject(std::string key, Coding *encoder);
        void saveInt(string key, int value);
        int readInt(string key);
        void saveBool(string key, bool value);
        bool readBool(string key);
        strong<Serializer> serializer_;
    };
    
    typedef reff<_Settings> Settings;
    
};

#endif /* settings_h */
