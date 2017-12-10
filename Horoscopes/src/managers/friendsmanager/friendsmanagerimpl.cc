//
//  friendsmanagerimpl.c
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "friendsmanagerimpl.h"
#include "managers/friendsprovider/facebookfriendsprovider.h"

namespace horo {

strong<FriendsProvider> FriendsManagerImpl::friendsProvider() {
    strong<FriendsProvider> provider = factory_->createFacebookFriendsProvider();
    return provider;
}
    
void FriendsManagerImpl::loadFacebookFriends() {
    LOG(LS_ERROR) << "ACHTUNG SUPERSTRONG RETAIN CYCLE (DOUBLE-CLOSE-LOCK)";
    strong<FriendsManagerImpl> aThis = this;
    std::function<void(Json::Value friends, std::string url, FriendsProvider::RequestStatus status)> safeCompletion = [aThis](Json::Value friends, std::string url, FriendsProvider::RequestStatus status) {
        LOG(LS_WARNING) << "status is: " << status << " with count: " << friends.size();
        if (status == FriendsProvider::Partial) {
            for (int i=0;i<friends.size();++i) {
                Json::Value personData = friends[i];
                string name = personData["name"].asString();
                string personUrl = personData["personUrl"].asString();
                string imageUrl = personData["imageUrl"].asString();
                strong<Person> person = new Person(new Zodiac(), name, imageUrl, personUrl, GenderUnknown, StatusReadyForRequest, TypeFriend, DateWrapper(), true);
                aThis->personDAO_->writePerson(person);
            }
            if (aThis->friendsUpdatedCallback_) {
                aThis->friendsUpdatedCallback_(aThis->personDAO_->readFacebookFriends());
            }
        }
        else if (status == FriendsProvider::AuthorizationRequired) {
            if (aThis->authorizationUrlCallback_) {
                std::vector<std::string> vec;
                aThis->authorizationUrlCallback_(url, vec);
            }
        }
    };
    provider_->requestFriendsList(safeCompletion);
}
    
void FriendsManagerImpl::cancelLoading() {
    provider_->cancelRequestingFriendsList();
}

void FriendsManagerImpl::updateUserInformationForPerson(strong<Person> person, std::function<void(bool success)> callback) {
    SCParameterAssert(person.get());
    std::function<void(DateWrapper birthday, bool success)> safeCompletion = [person, callback](DateWrapper birthday, bool success) {
        success = (birthday.month()>0);
        person->setBirthdayDate(birthday);
        person->setPersonStatus( (success) ? StatusCompleted : StatusFailed );
        ZodiacTypes type = Zodiac::zodiacTypeByDate(birthday);
        person->setZodiac(new Zodiac(type));
        if (callback) {
            callback(success);
        }
    };
    
    SCAssert(person->personUrl().length(), "person with corrupted personUrl() detected");
    if (!person->personUrl().length()) {
        if (callback) {
            callback(false);
        }
        return;
    }
    provider_->requestUserInformation(person->personUrl(), safeCompletion);
}

bool FriendsManagerImpl::webViewDidLoad(std::string url) {
    if (provider_.get()) {
        bool result = provider_->webViewDidLoad(url);
        return result;
    }
    return false;
}

set<strong<Person>> FriendsManagerImpl::readFacebookFriendsFromDatabase() {
    set<strong<Person>> result = personDAO_->readFacebookFriends();
    return result;
}

};
