//
//  predictionscreenmodel.cpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "predictionscreenmodelimpl.h"
#include "base/platform.h"

namespace horo {
    
PredictionScreenModelImpl::PredictionScreenModelImpl(strong<CoreComponents> components,
                                                     strong<HoroscopesService> horoscopesService,
                                                     strong<Person> person,
                                                     strong<Ntp> ntp)
    : components_(components)
    , horoscopesService_(horoscopesService)
    , person_(person)
    , ntp_(ntp)
    , yesterdayTimestamp_(0)
    , todayTimestamp_(0)
    , tomorrowTimestamp_(0)
    , weekTimestamp_(0)
    , monthTimestamp_(0)
    , requestCompleted_(false) {
        SCParameterAssert(components_.get());
        SCParameterAssert(horoscopesService_.get());
        SCParameterAssert(ntp_.get());
        if (!person_.get()) {
            person_ = components_->person_;
        }
        loadData();
}
    
PredictionScreenModelImpl::~PredictionScreenModelImpl() {
        
}

void zerous(tm *time) {
    time->tm_sec = 0;
    time->tm_min = 0;
    time->tm_hour = 0;
    time->tm_wday = 0;
    time->tm_yday = 0;
    time->tm_isdst = 0;
    time->tm_gmtoff = 0;
    time->tm_zone = 0;
}

void PredictionScreenModelImpl::loadData() {
    requestCompleted_ = false;
    yesterdayTimestamp_ = false;
    todayTimestamp_ = false;
    tomorrowTimestamp_ = false;
    weekTimestamp_ = false;
    monthTimestamp_ = false;
    
    ntp_->getServerTimeWithCompletion([this](double ti){
        double offset = timezoneOffset() * 60 * 60;
        ti += offset;
        tm todayTime = timeToTm(timestempToTime(ti));
        zerous(&todayTime);
        mktime(&todayTime);
        
        tm yesterdayTime = timeToTm(timestempToTime(ti));
        yesterdayTime.tm_mday--;
        zerous(&yesterdayTime);
        mktime(&yesterdayTime);
        
        tm tomorrowTime = timeToTm(timestempToTime(ti));
        tomorrowTime.tm_mday++;
        zerous(&tomorrowTime);
        mktime(&tomorrowTime);
        
        tm weekStartTime = timeToTm(timestempToTime(ti));
        while(weekStartTime.tm_wday != 1) {
            weekStartTime.tm_mday--;
            mktime(&weekStartTime);
        }
        zerous(&weekStartTime);
        mktime(&weekStartTime);
        
        tm monthStartTime = timeToTm(timestempToTime(ti));
        zerous(&monthStartTime);
        monthStartTime.tm_mday = 1;
        
        yesterdayTimestamp_ = tmToTimestamp(&yesterdayTime);
        todayTimestamp_ = tmToTimestamp(&todayTime);
        tomorrowTimestamp_ = tmToTimestamp(&tomorrowTime);
        weekTimestamp_ = tmToTimestamp(&weekStartTime);
        monthTimestamp_ = tmToTimestamp(&monthStartTime);
        
        if (requestCompleted_) {
            processFetchedHoroscopes();
        }
    });
    horoscopesService_->fetchHoroscopes(zodiac(), [this](strong<HoroscopeDTO> yesterday,
                                           strong<HoroscopeDTO> today,
                                           strong<HoroscopeDTO> tomorrow,
                                           strong<HoroscopeDTO> week,
                                           strong<HoroscopeDTO> month,
                                           strong<HoroscopeDTO> year){
        requestCompleted_ = true;
        yesterday_ = yesterday;
        today_ = today;
        tomorrow_ = tomorrow;
        week_ = week;
        month_ = month;
        year_ = year;
        if (yesterdayTimestamp_ || todayTimestamp_) {
            processFetchedHoroscopes();
        }
    });
}

void PredictionScreenModelImpl::processFetchedHoroscopes() {
    handleFetchedHoroscopes(yesterday_, today_, tomorrow_, week_, month_, year_);
}
    
strong<HoroscopeDTO> hasHoroscopeWithDate(long long date, vector<strong<HoroscopeDTO>> horoscopes) {
    for (strong<HoroscopeDTO> horoscope : horoscopes) {
        if (!horoscope.get()) {
            continue;
        }
        tm time = timeToTm(timestempToTime(horoscope->date()));
        zerous(&time);
        mktime(&time);
        long long timestamp = tmToTimestamp(&time);
        if (date == timestamp) {
            return horoscope;
        }
    }
    strong<HoroscopeDTO> result;
    return result;
}

void PredictionScreenModelImpl::handleFetchedHoroscopes(strong<HoroscopeDTO> yesterday,
                                                        strong<HoroscopeDTO> today,
                                                        strong<HoroscopeDTO> tomorrow,
                                                        strong<HoroscopeDTO> week,
                                                        strong<HoroscopeDTO> month,
                                                        strong<HoroscopeDTO> year) {
    list<string> predictions;
    list<string> tabsTitles;
    
    vector<strong<HoroscopeDTO>> daysHoroscopes = {yesterday, today, tomorrow};
    strong<HoroscopeDTO> newYesterdayHoroscope = hasHoroscopeWithDate(yesterdayTimestamp_, daysHoroscopes);
    strong<HoroscopeDTO> newTodayHoroscope = hasHoroscopeWithDate(todayTimestamp_, daysHoroscopes);
    strong<HoroscopeDTO> newTomorrowHoroscope = hasHoroscopeWithDate(tomorrowTimestamp_, daysHoroscopes);
    strong<HoroscopeDTO> newWeekHoroscope = hasHoroscopeWithDate(weekTimestamp_, {week});
    strong<HoroscopeDTO> newYearHoroscope = hasHoroscopeWithDate(monthTimestamp_, {month});
    
    vector<string> allTabsTitles = {"yesterday", "today", "tomorrow", "week", "month", "year"};
    
    vector<strong<HoroscopeDTO>> allHoroscopes = {newYesterdayHoroscope, newTodayHoroscope, newTomorrowHoroscope, newWeekHoroscope, newYearHoroscope, year};
    int i=0;
    for (auto h:allHoroscopes) {
        string title = allTabsTitles[i];
        if (h.get() && h->content().length()) {
            tabsTitles.push_back(title);
            predictions.push_back(h->content());
        }
        ++i;
    }
    
    tabsTitles_ = tabsTitles;
    predictions_ = predictions;
    if (callback_) {
        callback_(true);
    }
}

std::string PredictionScreenModelImpl::zodiacName() {
    if (person_.get()) {
        if (person_->zodiac().get()) {
            return person_->zodiac()->name();
        }
        return "Unknown";
    }
    return nullptr;
}

std::string PredictionScreenModelImpl::zodiacDateString() {
    DateWrapper startDate = Zodiac::startDateForType(zodiac()->type());
    DateWrapper endDate = Zodiac::endDateForType(zodiac()->type());
    SCAssert(startDate.day() && startDate.month() && endDate.day() && endDate.month(), "Parameters must be satisfied");
    string startMonth = loc(stringByMonth((Months)startDate.month()));
    string endMonth = loc(stringByMonth((Months)endDate.month()));
    string resultString = std::to_string(startDate.day()) + " " + startMonth + " - " + std::to_string(endDate.day()) + " " + endMonth;
    return resultString;
}
    
void PredictionScreenModelImpl::setDataFetchedCallback(std::function<void(bool success)> callback) {
    callback_ = callback;
}

void PredictionScreenModelImpl::noConnectionTapped() {
    loadData();
}

strong<Zodiac> PredictionScreenModelImpl::zodiac() {
    if (person_.get()) {
        return person_->zodiac();
    }
    return nullptr;
}

list<string> PredictionScreenModelImpl::tabsTitles() {
    return tabsTitles_;
}

list<string> PredictionScreenModelImpl::horoscopesText() {
    return predictions_;
}

bool PredictionScreenModelImpl::personExists() {
    return !(person_ == components_->person_);
}
    
void PredictionScreenModelImpl::personData(std::function<void(string imageUrl, string name, string birthday)> callback) {
    SCParameterAssert(callback);
    SCAssert(person_.get(), "Person must be initialized");
    if (!person_.get()) {
        return;
    }
    if (personExists()) {
        callback(person_->imageUrl(), person_->name(), person_->birthdayDate().toString());
        return;
    }
    callback("", "", "");
}

};

