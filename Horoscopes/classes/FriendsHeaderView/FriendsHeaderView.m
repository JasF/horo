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

- (void)setHeaderViewState:(HeaderViewStates)state
           allFriendsCount:(NSInteger)allFriendsCount {
    NSDictionary *dictionary = @{@(HeaderViewStateInvisible):@(YES),
                                 @(HeaderViewStateAuthorizing):@(NO),
                                 @(HeaderViewLoadingFriends):@(NO),
                                 @(HeaderViewSomeFriendsLoaded):@(NO)};
    NSDictionary *strings = @{@(HeaderViewStateInvisible):@"",
                              @(HeaderViewStateAuthorizing):@"authorizing",
                              @(HeaderViewLoadingFriends):@"loading_friends",
                              @(HeaderViewSomeFriendsLoaded):@"%@_friends_loaded"};
    self.hidden = [dictionary[@(state)] boolValue];
    NSString *text = L(strings[@(state)]);
    NSMutableAttributedString *attributedString = nil;
    
    if (state == HeaderViewSomeFriendsLoaded) {
        text = [NSString stringWithFormat:text, @(allFriendsCount)];
        attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange range = [text rangeOfString:@" "];
        NSCParameterAssert(range.location != NSNotFound);
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor greenColor]
                                 range:NSMakeRange(0, range.location)];
    }
    else {
        attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    }
    [self setAttributedText:attributedString];
}

@end
