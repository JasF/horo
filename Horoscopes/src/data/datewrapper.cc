//
//  datewrapper.c
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "datewrapper.h"

namespace horo {
    using namespace std;
    
    void DateWrapper::fromString(std::string string) {
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
    
    std::string DateWrapper::toString() {
        return std::to_string(day_) + '.' + std::to_string(month_) + '.' + std::to_string(year_);
    }
};
