//
//  FriendsViewController+Filtering.h
//  Horoscopes
//
//  Created by Jasf on 15.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonObjc.h"
#import "FriendsViewController.h"

@interface FriendsViewController (Filtering)
- (NSArray<PersonObjc *> *)horo_filterFriendsArray:(NSArray<PersonObjc *> *)array withString:(NSString *)text;
@end
