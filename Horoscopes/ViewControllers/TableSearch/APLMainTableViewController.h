/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The application's primary table view controller showing a list of products.
 */

#import "APLBaseTableViewController.h"
#include "viewmodels/friendsscreenviewmodel/friendsscreenviewmodel.h"

@interface APLMainTableViewController : APLBaseTableViewController
@property (assign, nonatomic) strong<horo::FriendsScreenViewModel> viewModel;
@end
