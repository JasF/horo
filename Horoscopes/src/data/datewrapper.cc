//
//  datewrapper.c
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "datewrapper.h"

namespace horo {
    void DateWrapper::fromString(string string) {
        int counter = 0;
        for(auto part : separateString(string, '.')) {
            int value = stoi(part);
            switch (counter++) {
                case 0: day_ = value; break;
                case 1: month_ = value; break;
                case 2: year_ = value; break;
            }
        }
    }
    
    string DateWrapper::toString() {
        if (!day_ && !month_ && !year_) {
            return "";
        }
        string result = to_string(day_) + "." + to_string(month_);
        if (year_) {
            result += "." + std::to_string(year_);
        }
        return result;
    }
    
};
