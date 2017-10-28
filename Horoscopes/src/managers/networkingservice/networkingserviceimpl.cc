//
//  networkingservice.cpp
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "networkingserviceimpl.h"
#include "rtc_base/logging.h"

namespace horo {

NetworkingServiceImpl::NetworkingServiceImpl() {
    
}

NetworkingServiceImpl::~NetworkingServiceImpl() {
    
}
    
void NetworkingServiceImpl::beginRequest(std::string url, std::function<void(Json::Value value)> callback) {
    LOG(LS_ERROR) << "url: " << url;
}

};

