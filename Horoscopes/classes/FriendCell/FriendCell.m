//
//  FriendCell.m
//  Horoscopes
//
//  Created by Jasf on 09.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "FriendCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

static CGFloat const kMainImageViewHalfHeight = 25.f;

@interface FriendCell ()
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;
@end

@implementation FriendCell

#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];
    _mainImageView.layer.cornerRadius = kMainImageViewHalfHeight;
    _mainImageView.layer.masksToBounds = YES;
}

#pragma mark - Public Methods
- (void)setImageURL:(NSURL *)imageURL
               name:(NSString *)name
           birthday:(NSString *)birthday {
    if (imageURL) {
        [_mainImageView sd_setImageWithURL:imageURL];
    }
    _nameLabel.text = name;
    _birthdayLabel.text = birthday;
}

@end
