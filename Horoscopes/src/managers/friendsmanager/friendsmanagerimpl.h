//
//  friendsmanagerimpl.h
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef friendsmanagerimpl_h
#define friendsmanagerimpl_h

#include "friendsmanager.h"
#include "managers/friendsproviderfactory/friendsproviderfactory.h"
#include "managers/persondao/persondao.h"

namespace horo {
    class FriendsManagerImpl : public FriendsManager {
    public:
        FriendsManagerImpl(strong<FriendsProviderFactory> factory,
                           strong<PersonDAO> personDAO)
        : factory_(factory),
        personDAO_(personDAO)
        {
            provider_ = friendsProvider();
            SCParameterAssert(factory_.get());
            SCParameterAssert(personDAO_.get());
            SCParameterAssert(provider_.get());
            
            personDAO_->create();
        }
        ~FriendsManagerImpl() override {}
    
    public:
        void loadFacebookFriends(void *webViewControllerUIDelegate) override;
        void cancelLoading() override;
        bool webViewDidLoad(std::string url) override;
        set<strong<Person>> readFacebookFriendsFromDatabase() override;
        void updateUserInformationForPerson(strong<Person> person, std::function<void(bool success)> callback, void *webViewControllerUIDelegate) override;
        
    private:
        strong<FriendsProvider> friendsProvider();
        void birthdayUpdated(strong<Person> person, DateWrapper birthday, bool success, std::function<void(bool success)> callback);
        
    private:
        strong<FriendsProviderFactory> factory_;
        strong<FriendsProvider> provider_;
        strong<PersonDAO> personDAO_;
    };
};

#endif /* friendsmanagerimpl_h */
