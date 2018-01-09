//
//  FriendCell.h
//  Horoscopes
//
//  Created by Jasf on 09.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell
- (void)setImageURL:(NSURL *)imageURL
               name:(NSString *)name
           birthday:(NSString *)birthday;
@end
