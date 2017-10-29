//
//  FacebookBanagerObjc.m
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "FacebookBanagerObjc.h"
#include "managers/facebookmanager/facebookmanagerimpl.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "NSDictionary+Horo.h"

namespace horo {
    
    class FacebookManagerObjc : public FacebookManager {
    public:
        FacebookManagerObjc() {}
        ~FacebookManagerObjc() override {}
        static FacebookManagerObjc *shared() {
            static FacebookManagerObjc *sharedInstance = nullptr;
            if (!sharedInstance) {
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    sharedInstance = new FacebookManagerObjc();
                });
            }
            return sharedInstance;
        }
    public:
        void requestPersonalInformation(std::function<void(dictionary userInfo)> callback) override {
            if ([FBSDKAccessToken currentAccessToken])
            {
                NSLog(@"isndie con");
                NSMutableDictionary *parameters = [NSMutableDictionary new];
                [parameters setValue:@"id,name,email,birthday,gender,hometown" forKey:@"fields"];
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                 {
                     if ([result isKindOfClass:[NSDictionary class]]) {
                         Json::Value value = [(NSDictionary *)result horo_jsonValue];
                         if (callback) {
                             callback(value);
                         }
                         return;
                     }
                     NSLog(@"isndie handler");
                     NSLog(@"result is %@",result);
                     NSLog(@"error is %@",[error localizedDescription]);
                     
                     NSDictionary *userInfo=result;
                     //email=[userInfo objectForKey:@"email"];
                     // name=[userInfo objectForKey:@"name"];
                     NSString *facebookId=[userInfo objectForKey:@"id"];
                     NSString *imageUrl = [[NSString alloc] initWithFormat: @"http://graph.facebook.com/%@/picture?type=large", facebookId];
                     NSLog(@"iamge ur lsi %@",imageUrl);
                     // [self isFBLoginFirstTime];
                     if (callback) {
                         dictionary empty;
                         callback(empty);
                     }
                 }];
            }
            else
            {
                NSLog(@"no token");
            }
        }
    };
};

@implementation FacebookBanagerObjc

+ (void)load {
    horo::FacebookManagerImpl::setPrivateInstance(horo::FacebookManagerObjc::shared());
}

@end
