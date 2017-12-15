//
//  FriendsBaseViewController.h
//  Horoscopes
//
//  Created by Jasf on 12.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonObjc.h"

@interface FriendsBaseViewController : UITableViewController
@property (nonatomic, strong) NSArray<PersonObjc *> *friends;
@property (assign, nonatomic) NSInteger friendsSection;
- (void)personStatusChanged:(PersonObjc *)person;
- (PersonObjc *)personFromCellAtIndexPath:(NSIndexPath *)indexPath;
@end
