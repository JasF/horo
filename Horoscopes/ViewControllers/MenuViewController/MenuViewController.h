//
//  MenuViewController.h
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "viewmodels/menuscreenviewmodel/menuscreenviewmodel.h"

@interface MenuViewController : UITableViewController
@property (assign, nonatomic) strong<horo::MenuScreenViewModel> viewModel;
@end
