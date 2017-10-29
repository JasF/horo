//
//  facebookloginmanager.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "facebookloginmanager.h"

namespace horo {
  
    using namespace std;
    
FacebookLoginManager::FacebookLoginManager(strong<FacebookManager> facebookManager)
: facebookManager_(facebookManager) {
    SCParameterAssert(facebookManager_.get());
}

FacebookLoginManager::~FacebookLoginManager() {
    
}

void FacebookLoginManager::requestUserInformation(std::function<void(strong<Person> person)> callback) {
    facebookManager_->requestPersonalInformation([callback](dictionary data){
        LOG(LS_WARNING) << "FB userInfo: " << data.toStyledString();
        string birthday = data["birthday"].asString();
        // string email = data["email"];
        string name = data["name"].asString();
        string gender = data["gender"].asString();
        
        if (!birthday.length() || !name.length()) {
            if (callback) {
                callback(nullptr);
            }
            return;
        }
        // теперь нужно из даты рождения получить знак зодиака
        //stringByDate
        //strong<Person> = new Person();
        if (callback) {
            callback(nullptr);
        }
    });
}
    
};

