//
//  SettingsCell.h
//  Horoscopes
//
//  Created by Jasf on 27.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsCell : UITableViewCell
@property (strong, nonatomic) NSString *text;
- (void)setSwitcherOn:(BOOL)on;
@end
