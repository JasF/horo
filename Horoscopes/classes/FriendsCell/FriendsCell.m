//
//  FriendsCell.m
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "FriendsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

static CGFloat const kAnimationDuration = 0.5f;
static CGFloat const kHighlightedAlpha = 0.5f;

@interface FriendsCell ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthdayDateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainImageViewTrailing;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainImageViewHeightAspectRatio;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation FriendsCell

#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Public Methods
- (void)setName:(NSString *)name
       birthday:(NSString *)birthday
       imageUrl:(NSString *)imageUrl {
    _nameLabel.text = name;
    _birthdayLabel.text = L(@"birthday");
    _birthdayDateLabel.text = birthday;
    if (imageUrl.length) {
        [_mainImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
}

- (void)setActivityIndicatorAnimationEnabled:(BOOL)enabled {
    if (enabled) {
        [_activityIndicator startAnimating];
    }
    else {
        [_activityIndicator stopAnimating];
    }
}

#pragma mark - Overriden Methods - UITableViewCell
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    UIColor *backgroundColor = (highlighted) ? [[UIColor whiteColor] colorWithAlphaComponent:kHighlightedAlpha] : [UIColor clearColor];
    [self setNeedsLayout];
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.contentView.backgroundColor = backgroundColor;
                     }];
}

@end
