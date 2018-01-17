//
//  AnalyticsProviders.m
//  Horoscopes
//
//  Created by Jasf on 17.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "AnalyticsProviders.h"

@import FirebaseAnalytics;

@implementation AnalyticsProviders

- (void)logEvent:(NSString *)eventName {
    [FIRAnalytics logEventWithName:eventName
                        parameters:nil];
}

- (void)logEvent:(NSString *)eventName
      parameters:(NSDictionary *)parameters {
    [FIRAnalytics logEventWithName:eventName
                        parameters:parameters];
}

@end
