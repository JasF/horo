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

@interface FriendsResultsViewController : FriendsBaseViewController
@property (nonatomic, copy, nonnull) void (^didSelectPerson)(PersonObjc * _Nonnull person);
@end
