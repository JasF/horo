//
//  AnalyticsProviders.h
//  Horoscopes
//
//  Created by Jasf on 17.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticsProviders : NSObject
- (void)logEvent:(NSString *)eventName;
- (void)logEvent:(NSString *)eventName parameters:(NSDictionary *)parameters;
@end
