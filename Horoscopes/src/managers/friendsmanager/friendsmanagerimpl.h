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
            SCParameterAssert(factory_.get());
            SCParameterAssert(personDAO_.get());
            
            personDAO_->create();
        }
        ~FriendsManagerImpl() override {}
    public:
        void loadFacebookFriends() override;
        bool webViewDidLoad(std::string url) override;
        virtual set<strong<Person>> readFacebookFriendsFromDatabase()override;
    private:
        strong<FriendsProviderFactory> factory_;
        strong<FriendsProvider> provider_;
        strong<PersonDAO> personDAO_;
    };
};

#endif /* friendsmanagerimpl_h */
