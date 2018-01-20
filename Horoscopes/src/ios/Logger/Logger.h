//
//  Logger.h
//  Horoscopes
//
//  Created by Jasf on 22.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FeedbackLog(a, ...) [[Logger shared] log:a, ...];
@interface Logger : NSObject
+ (instancetype)shared;
- (void)log:(NSString *)format, ...;
- (NSString *)readAll;
@end
