//
//  MenuViewController.h
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZodiacsLayoutController.h"
#include "viewmodels/menuscreenviewmodel/menuscreenviewmodel.h"

using namespace horo;

@interface MenuViewController : UITableViewController
@property (assign, nonatomic) strong<MenuScreenViewModel> viewModel;
@property (strong, nonatomic) ZodiacsLayoutController *zodiacsLayoutController;
@end
