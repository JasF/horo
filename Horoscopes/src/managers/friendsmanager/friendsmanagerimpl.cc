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

void FriendsManagerImpl::loadFacebookFriends() {
    strong<FriendsProvider> friendsProvider = factory_->createFacebookFriendsProvider();
    SCAssert(friendsProvider.get(), "friendsProvider zero");
    if (!friendsProvider.get()) {
        return;
    }
    provider_ = friendsProvider;
    strong<FriendsManagerImpl> aThis = this;
    std::function<void(Json::Value friends, std::string url, FriendsProvider::RequestStatus status)> safeCompletion = [aThis](Json::Value friends, std::string url, FriendsProvider::RequestStatus status) {
        LOG(LS_WARNING) << "status is: " << status << " with count: " << friends.size();
        if (status == FriendsProvider::Partial) {
            for (int i=0;i<friends.size();++i) {
                Json::Value personData = friends[i];
                string name = personData["name"].asString();
                string personUrl = personData["personUrl"].asString();
                string imageUrl = personData["imageUrl"].asString();
                /*
                strong<Zodiac> zodiac,
                std::string name,
                Gender gender,
                PersonStatus status,
                PersonType type,
                DateWrapper birthdayDate,
                bool withFacebook);
                */
                strong<Person> person = new Person(new Zodiac(), name, imageUrl, personUrl, GenderUnknown, StatusReadyForRequest, TypeFriend, DateWrapper(), true);
                aThis->personDAO_->writePerson(person);
            }
            //кладем в сторейдж и потом считаем общее число
            /*
            LOG(LS_WARNING) << "friends count: " << persons.size();
            for (int i=0;i<persons.size();++i) {
                Json::Value person = persons[i];
                string name = person["name"].asString();
                string url = person["personUrl"].asString();
                LOG(LS_WARNING) << "name: " << name << "; url: " << url;
            }
            */
            return;
        }
        if (status == FriendsProvider::AuthorizationRequired) {
            if (aThis->authorizationUrlCallback_) {
                std::vector<std::string> vec;
                aThis->authorizationUrlCallback_(url, vec);
            }
            return;
        }
    };
    provider_->requestFriendsList(safeCompletion);
}
    
bool FriendsManagerImpl::webViewDidLoad(std::string url) {
    if (provider_.get()) {
        bool result = provider_->webViewDidLoad(url);
        return result;
    }
    return false;
}

};
