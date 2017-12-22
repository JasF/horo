//
//  FeedbackManager.h
//  Horoscopes
//
//  Created by Jasf on 22.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedbackManager : NSObject
+ (instancetype)shared;
- (void)showFeedbackController:(UIViewController *)parentViewController;
@end
