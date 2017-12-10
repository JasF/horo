//
//  FriendsCell.h
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsCell : UITableViewCell
- (void)setName:(NSString *)name
       birthday:(NSString *)birthday
       imageUrl:(NSString *)imageUrl;
@end
