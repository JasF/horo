//
//  FriendCell.m
//  Horoscopes
//
//  Created by Jasf on 07.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _nameLabel.text = @"";
    _birthdayLabel.text = @"";
}

@end
