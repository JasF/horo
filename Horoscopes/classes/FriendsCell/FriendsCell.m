//
//  FriendsCell.m
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "FriendsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FriendsCell ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@end

@implementation FriendsCell

- (void)setName:(NSString *)name
       birthday:(NSString *)birthday
       imageUrl:(NSString *)imageUrl {
    _nameLabel.text = name;
    _birthdayLabel.text = birthday;
    if (imageUrl.length) {
        [_mainImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
}

@end
