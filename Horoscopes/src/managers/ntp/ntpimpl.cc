//
//  ntpimpl.c
//  Horoscopes
//
//  Created by Jasf on 07.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#include "ntpimpl.h"

namespace horo {

static Ntp *privateInstance = nullptr;
    
void NtpImpl::setPrivateInstance(Ntp *instance) {
    privateInstance = instance;
}

NtpImpl::NtpImpl() {
    
}

NtpImpl::~NtpImpl() {
    
}

void NtpImpl::getServerTimeWithCompletion(std::function<void(double ti)> callback) {
    if (privateInstance) {
        privateInstance->getServerTimeWithCompletion(callback);
    }
}

};
