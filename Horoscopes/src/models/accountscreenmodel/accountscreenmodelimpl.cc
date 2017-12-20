//
//  accountscreenmodelimpl.c
//  Horoscopes
//
//  Created by Jasf on 19.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "accountscreenmodelimpl.h"

namespace horo {
  
AccountScreenModelImpl::AccountScreenModelImpl(strong<CoreComponents> components, strong<Settings> settings, strong<LoginManagerFactory> loginManagerFactory)
    : components_(components),
    settings_(settings),
    loginManagerFactory_(loginManagerFactory) {
    SCParameterAssert(components_.get());
    SCParameterAssert(settings_.get());
    SCParameterAssert(loginManagerFactory_.get());
}

AccountScreenModelImpl::~AccountScreenModelImpl() {
    
}
    
void AccountScreenModelImpl::loggedInOnFacebook() {
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
        handlePerson(person);
    });
}

void AccountScreenModelImpl::userLoggedOut() {
    strong<Person> person = components_->person_;
    person->logout();
}

void AccountScreenModelImpl::personRepresentation(function<void(std::string imageUrl, std::string name, horo::DateWrapper birthday)> callback) {
    strong<Person> person = components_->person_;
    if (!person.get()) {
        if (callback) {
            callback("", "", DateWrapper());
        }
        return;
    }
    if (callback) {
        callback(person->imageUrl(), person->name(), person->birthdayDate());
    }
}

void AccountScreenModelImpl::handlePerson(strong<Person> person) {
    settings_->setCurrentPerson(person);
    components_->person_ = person;
    if (personGatheredCallback_) {
        personGatheredCallback_(true);
    }
}
    
void AccountScreenModelImpl::birthdayDateChanged(DateWrapper wrapper) {
    components_->person_->setBirthdayDate(wrapper);
    settings_->setCurrentPerson(components_->person_);
}

};
