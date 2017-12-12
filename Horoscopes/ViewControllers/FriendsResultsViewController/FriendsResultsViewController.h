//
//  FriendsResultsViewController.h
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "viewmodels/friendsscreenviewmodel/friendsscreenviewmodel.h"
#import "FriendsBaseViewController.h"
#import <UIKit/UIKit.h>
#import "PersonObjc.h"

@interface FriendsResultsViewController : FriendsBaseViewController
@property (strong, nonatomic) NSArray<PersonObjc *> *filteredFriends;
- (id)init NS_UNAVAILABLE;
- (id)new NS_UNAVAILABLE;
@end
