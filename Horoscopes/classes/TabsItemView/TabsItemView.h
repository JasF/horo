//
//  TabsItemView.h
//  Horoscopes
//
//  Created by Jasf on 29.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, TabItemViewTouchState) {
    TabItemViewTouchBegin,
    TabItemViewTouchCancelled,
    TabItemViewTouchFinished
};

@interface TabsItemView : UIView
@property (nonatomic, copy) void (^touchesBlock)(TabItemViewTouchState state);
- (void)setTitle:(NSString *)title;
- (void)setItemHighlighted:(BOOL)highlighted;
@end
 
