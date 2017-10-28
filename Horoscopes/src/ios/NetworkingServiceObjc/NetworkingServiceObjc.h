//
//  NetworkingServiceImpl.h
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "../src/managers/networkingservice/networkingservice.h"

namespace horo {
  
    class NetworkingServiceObjc : public NetworkingService {
    public:
        NetworkingServiceObjc();
        ~NetworkingServiceObjc() override;
        virtual void beginRequest(std::string url, std::function<void(Json::Value value)> callback);
    };
};

@interface NetworkingServiceImpl : NSObject

@end
