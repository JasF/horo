//
//  FriendsViewController.h
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "viewmodels/friendsscreenviewmodel/friendsscreenviewmodel.h"

@interface FriendsViewController : UIViewController
@property (assign, nonatomic) strong<horo::FriendsScreenViewModel> viewModel;
@end
