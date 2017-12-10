//
//  FriendsHeaderView.h
//  Horoscopes
//
//  Created by Jasf on 10.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HeaderViewStates) {
    HeaderViewStateInvisible,
    HeaderViewStateAuthorizing,
    HeaderViewLoadingFriends,
    HeaderViewSomeFriendsLoaded
};

@interface FriendsHeaderView : UIView
- (void)setText:(NSString *)text;
- (void)setAttributedText:(NSAttributedString *)text;
@end
