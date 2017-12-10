//
//  FriendsHeaderView.m
//  Horoscopes
//
//  Created by Jasf on 10.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "FriendsHeaderView.h"

@interface FriendsHeaderView ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UILabel *label;
@end

@implementation FriendsHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [_indicator startAnimating];
}

- (void)setText:(NSString *)text {
    _label.text = text;
}

- (void)setAttributedText:(NSAttributedString *)text {
    _label.attributedText = text;
}

@end
