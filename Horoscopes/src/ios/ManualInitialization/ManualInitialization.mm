//
//  ManualInitialization.m
//  Horoscopes
//
//  Created by Jasf on 31.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "ManualInitialization.h"
#import "DatabaseObjc.h"
#import "SerializerObjc.h"
#import "FirestoreObjc.h"
#import "FacebookBanagerObjc.h"
#import "ScreensManagerObjc.h"
#import "WebViewServiceFactoryObjc.h"
#import "NotificationsObjc.h"
#import "NtpObjc.h"

@implementation ManualInitialization
+ (void)load {
    [self doLoading];
}
+ (void)doLoading {
    NSArray *array = @[[DatabaseObjc class],
                       [SerializerObjc class],
                       [FirestoreObjc class],
                       [FacebookBanagerObjc class],
                       [ScreensManagerObjc class],
                       [WebViewServiceFactoryObjc class],
                       [NotificationsObjc class],
                       [NtpObjc class]];
    for (Class cls in array) {
        NSCAssert([cls respondsToSelector:@selector(doLoading)], @"Unknown classObjc: %@", cls);
        if ([cls respondsToSelector:@selector(doLoading)]) {
            [cls doLoading];
        }
    }
}
@end
