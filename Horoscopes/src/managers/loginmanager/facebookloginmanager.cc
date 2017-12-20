//
//  facebookloginmanager.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "facebookloginmanager.h"
#include <vector>
#include <sstream>

namespace horo {
  
    using namespace std;
    
FacebookLoginManager::FacebookLoginManager(strong<FacebookManager> facebookManager)
: facebookManager_(facebookManager) {
    SCParameterAssert(facebookManager_.get());
}

FacebookLoginManager::~FacebookLoginManager() {
    
}

std::vector<std::string> toVector(std::string string, char delimeter) {
    std::vector<std::string> array;
    std::stringstream ss(string);
    std::string tmp;
    while(std::getline(ss, tmp, delimeter))
    {
        array.push_back(tmp);
    }
    return array;
}
    
void FacebookLoginManager::requestUserInformation(std::function<void(strong<Person> person)> callback) {
    facebookManager_->requestPersonalInformation([callback](dictionary data){
        LOG(LS_WARNING) << "FB userInfo: " << data.toStyledString();
        string birthday = data["birthday"].asString();
        string name = data["name"].asString();
        string genderString = data["gender"].asString();
        string id = data["id"].asString();
        string imageUrl = "https://graph.facebook.com/" + id + "/picture?type=normal";
        std::vector<std::string> birthdayVector = toVector(birthday, '/');
        if (birthdayVector.size() != 3 || !name.length()) {
            if (callback) {
                callback(nullptr);
            }
            return;
        }
        int day = std::stoi(birthdayVector[0]);
        int month = std::stoi(birthdayVector[1]);
        int year = std::stoi(birthdayVector[2]);
        
        ZodiacTypes type = Zodiac::zodiacTypeByDate((Months)month, day, year);
        
        if (type == Unknown) {
            if (callback) {
                callback(nullptr);
            }
            return;
        }
        Json::Value genders;
        genders["male"] = Male;
        genders["female"] = Female;
        Gender gender = (Gender)genders[genderString].asInt();
        
        strong<Zodiac> zodiac = new Zodiac(type);
        strong<Person> person = new Person(zodiac, name, imageUrl, "", gender, StatusCompleted, TypeUser, DateWrapper(day, month, year), true);
        if (callback) {
            callback(person);
        }
    });
}
    
};

