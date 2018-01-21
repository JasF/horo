//
//  ZodiacsCell.h
//  Horoscopes
//
//  Created by Jasf on 20.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "ZodiacsLayoutController.h"

@interface ZodiacsCell : UITableViewCell
- (void)setItems:(NSArray *)items;
- (void)setZodiacsLayoutController:(ZodiacsLayoutController *)zodiacsLayoutController;
@end
