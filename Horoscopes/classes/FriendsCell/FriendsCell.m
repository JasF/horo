//
//  FriendsCell.m
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "FriendsCell.h"

@interface FriendsCell ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;
@end

@implementation FriendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setName:(NSString *)name
       birthday:(NSString *)birthday {
    _nameLabel.text = name;
    _birthdayLabel.text = birthday;
}

@end
