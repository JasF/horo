//
//  menuscreenmodelimpl.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "menuscreenmodelimpl.h"

namespace horo {
  
    MenuScreenModelImpl::MenuScreenModelImpl(strong<CoreComponents> components,
                                               strong<LoginManagerFactory> loginManagerFactory,
                                               strong<Settings> settings)
    : components_(components)
    , loginManagerFactory_(loginManagerFactory)
    , settings_(settings) {
        SCParameterAssert(components_.get());
        SCParameterAssert(loginManagerFactory_.get());
        SCParameterAssert(settings_.get());
    }
    
    MenuScreenModelImpl::~MenuScreenModelImpl() {
        
    }
    
    void MenuScreenModelImpl::loginOnFacebook() {
        loginManager_ = loginManagerFactory_->createFacebookLoginManager();
        SCAssert(loginManager_.get(), "login manager is not allocated");
        if (!loginManager_.get()) {
            return;
        }
        loginManager_->requestUserInformation([this](strong<Person> person) {
            // set to application storage
            
            if (!person.get()) {
                if (personGatheredCallback_) {
                    personGatheredCallback_(false);
                }
                return;
            }
            settings_->setCurrentPerson(person);
            components_->person_ = person;
            if (personGatheredCallback_) {
                personGatheredCallback_(true);
            }
        });
    }
    
    void MenuScreenModelImpl::dataForZodiacRow(int zodiacRowIndex, function<void(string leftZodiacName, string rightZodiacName)> callback) {
        SCParameterAssert(zodiacRowIndex >= 0 && zodiacRowIndex <= 6);
        SCParameterAssert(callback);
        int leftType = zodiacRowIndex*2 + static_cast<int>(Aquarius);
        int rightType = leftType + 1;
        strong<Zodiac> leftZodiac = new Zodiac(static_cast<ZodiacTypes>(leftType));
        strong<Zodiac> rightZodiac = new Zodiac(static_cast<ZodiacTypes>(rightType));
        callback(leftZodiac->name(), rightZodiac->name());
    }
    
};
