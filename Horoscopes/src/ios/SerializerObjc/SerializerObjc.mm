//
//  SerializerObjc.m
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "SerializerObjc.h"
#include "managers/serializer/serializerimpl.h"
#import <UIKit/UIApplication.h>

namespace horo {
  
    class SerializerObjc : public Serializer {
    public:
        static SerializerObjc *shared() {
            static SerializerObjc *sharedInstance = nullptr;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                sharedInstance = new SerializerObjc();
            });
            return sharedInstance;
        }
        SerializerObjc() {}
        ~SerializerObjc() override {}
        
        void saveString(std::string key, std::string value) override {
            NSCParameterAssert(key.length());
            NSString *sKey = [[NSString alloc] initWithCString:key.c_str() encoding:NSUTF8StringEncoding];
            NSString *sValue = [[NSString alloc] initWithCString:value.c_str() encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults] setObject:sValue forKey:sKey];
        }
        
        std::string loadString(std::string key) override {
            
            NSCParameterAssert(key.length());
            NSString *sKey = [[NSString alloc] initWithCString:key.c_str() encoding:NSUTF8StringEncoding];
            NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:sKey];
            if (![value isKindOfClass:[NSString class]]) {
                return "";
            }
            std::string csValue = [value UTF8String];
            return csValue;
        }
    };
    
};

@implementation SerializerObjc

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationDidEnterBackgroundNotification object:nil];
    horo::SerializerImpl::setPrivateInstance(horo::SerializerObjc::shared());
}

+ (void)save {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
