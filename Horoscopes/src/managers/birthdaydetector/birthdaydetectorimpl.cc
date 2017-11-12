//
//  birthdaydetectorimpl.c
//  Horoscopes
//
//  Created by Jasf on 12.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "birthdaydetectorimpl.h"
#include "json/reader.h"
#include "base/platform.h"
#include <codecvt>
#include <iostream>
#include <locale>
#include "data/zodiac.h"
#include <chrono>
#include "time.h"
#include <sstream>
#include <iostream>
#include "data/datewrapper.h"

namespace horo {
    
BirthdayDetectorImpl::BirthdayDetectorImpl() {
    Json::Reader reader;
    string locstringJson = contentOfFile("locdates", "json");
    bool success = reader.parse(locstringJson, locdates_);
    SCAssert(locstringJson.length() && success, "locstringJson parsing error");
    string birthdayslocstrJson = contentOfFile("birthdayslocstr", "json");
    success = reader.parse(birthdayslocstrJson, birthdayslocstr_);
    SCAssert(birthdayslocstrJson.length() && success, "birthdayslocstrJson parsing error");
}
    
list<string> BirthdayDetectorImpl::isLocalizedBirthdayString(std::string birthdayString) {
    birthdayString = toLowerCase(birthdayString);
    list<string> results;
    LOG(LS_WARNING) << "birthdayString: " << birthdayString;
    Json::Value value = birthdayslocstr_[birthdayString];
    if (value.isArray()) {
        for (int i=0;i<value.size();++i) {
            results.push_back(value[i].asString());
        }
    }
    return results;
}
  
list<string> process(string source) {
    string result = toLowerCase(source);
    for (int i=0;i<9;++i) {
        result = ReplaceAll(result, std::to_string(i), "");
    }
    result = ReplaceAll(result, "  ", " ");
    result = ReplaceAll(result, "  ", " ");
    auto words = separateString(result, ' ');
    list<string> resultArray;
    for (auto word: words) {
        auto wideWord =toUtf16(word);
        if (wideWord.length() >= 3) {
            resultArray.push_back(word);
        }
    }
    return resultArray;
}
    
bool arraysOfStringsAcceptableTheSame(list<string> one, list<string> two) {
    for (auto a: one) {
        if (std::find(two.begin(), two.end(), a) == two.end()) {
            return false;
        }
    }
    return true;
}
    
list<int> getNumbers(string source) {
    list<int> result;
    for (auto part : separateString(source, ' ')) {
        std::stringstream convertor;
        int number;
        convertor << part;
        convertor >> number;
        if (number) {
            result.push_back(number);
        }
    }
    return result;
}

DateWrapper BirthdayDetectorImpl::timestampForDateString(string dateString, list<string> languageCodes) {
    auto aWords = process(dateString);
    int monthIndex = MonthUnknown;
    for (string code : languageCodes) {
        Json::Value monthes = locdates_[code];
        if (!monthes.isArray()) {
            continue;
        }
        for (int i=0;i<monthes.size();++i) {
            string monthString = monthes[i].asString();
            auto forCompare = process(monthString);
            if (arraysOfStringsAcceptableTheSame(aWords, forCompare)) {
                monthIndex = i + 1;
                break;
            }
        }
        if (monthIndex != MonthUnknown) {
            break;
        }
    }
    if (monthIndex == MonthUnknown) {
        return DateWrapper();
    }
    int day = 0;
    int year = 0;
    
    list<int> numbers = getNumbers(dateString);
    for (int number : numbers) {
        if (number > 1900) {
            year = number;
        }
        else if (number < 32) {
            day = number;
        }
    }
    if (!day) {
        return DateWrapper();
    }
    return DateWrapper();
}

};
