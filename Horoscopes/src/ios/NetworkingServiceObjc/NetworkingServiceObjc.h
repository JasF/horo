//
//  NetworkingServiceImpl.h
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "../src/managers/networkingservice/networkingservice.h"
#include "managers/networkingservice/networkingservicefactory.h"

namespace horo {
    class NetworkingServiceObjc : public NetworkingService {
    public:
        NetworkingServiceObjc(NetworkingServiceFactory *factory);
        ~NetworkingServiceObjc() override;
        void beginRequest(std::string path,
                              Json::Value parameters,
                                  std::function<void(strong<HttpResponse> response, Json::Value value)> successBlock,
                                  std::function<void(error err)> failBlock) override;
    private:
        NetworkingServiceFactory *factory_;
    };
};
