//
//  NtpObjc.m
//  Horoscopes
//
//  Created by Jasf on 07.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "NtpObjc.h"
#include "managers/ntp/ntpimpl.h"
#import "ios-ntp.h"
#import "NetAssociation.h"

static CGFloat const kTimeoutDelay = 4.f;
static NSString *const kDefaultNtpServer = @"time.apple.com";

@interface NtpObjc ()
+ (instancetype)shared;
- (void)subscribeForTimeout;
@end

namespace horo {
    class NtpCC : public Ntp {
    public:
        NtpCC() : net_([[NetAssociation alloc] initWithServerName:[NetAssociation ipAddrFromName:kDefaultNtpServer]])
        , hasError_(false) {
            NSCParameterAssert(net_);
            net_.delegate = [NtpObjc shared];
        }
        ~NtpCC() override {}
        static NtpCC *shared() {
            static NtpCC *sharedInstance = nullptr;
            if (!sharedInstance) {
                sharedInstance = new NtpCC();
            }
            return sharedInstance;
        }
        
        void getServerTimeWithCompletion(std::function<void(double ti)> callback) override {
            callback_ = callback;
            if (hasError_) {
                timeout();
                return;
            }
            [[NtpObjc shared] subscribeForTimeout];
            [net_ sendTimeQuery];
        }
        
        void reportFromDelegate() {
            NSDate *serverDate = [[NSDate date] dateByAddingTimeInterval:-net_.offset];
            if (callback_) {
                callback_(serverDate.timeIntervalSince1970);
                callback_ = nullptr;
            }
        }
        
        void timeout() {
            hasError_ = true;
            if (callback_) {
                callback_([NSDate date].timeIntervalSince1970);
                callback_ = nullptr;
            }
        }
        
    private:
        std::function<void(double referenceTI)> callback_;
        NetAssociation *net_;
        bool hasError_;
    };
};

@interface NtpObjc () <NetAssociationDelegate>
@end

@implementation NtpObjc
+ (instancetype)shared {
    static NtpObjc *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NtpObjc new];
    });
    return sharedInstance;
}
+ (void)doLoading {
    horo::NtpImpl::setPrivateInstance(horo::NtpCC::shared());
}

#pragma mark - NetAssociationDelegate
- (void)reportFromDelegate {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeout) object:nil];
    horo::NtpCC::shared()->reportFromDelegate();
}

- (void)subscribeForTimeout {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeout) object:nil];
    [self performSelector:@selector(timeout) withObject:nil afterDelay:kTimeoutDelay];
}

#pragma mark - Observers
- (void)timeout {
    horo::NtpCC::shared()->timeout();
}

@end
