//
//  Tabs.m
//  Horoscopes
//
//  Created by Jasf on 29.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "Tabs.h"
#import "TabsItemView.h"
#import "UIView+TKGeometry.h"

@interface Tabs ()
@property (strong, nonatomic) NSMutableArray *itemViews;
@end

@implementation Tabs

#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Public Methods
- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    for (TabsItemView *itemView in _itemViews) {
        [itemView removeFromSuperview];
    }
    NSMutableArray *views = [NSMutableArray new];
    for (NSString *title in _titles) {
        TabsItemView *itemView = (TabsItemView *)[[NSBundle mainBundle] loadNibNamed:@"TabsItemView" owner:nil options:nil].firstObject;
        [itemView setTitle:title];
        [self addSubview:itemView];
        [views addObject:itemView];
    }
    _itemViews = [views copy];
    [self setNeedsLayout];
}

#pragma mark - Layouting
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat allWidths = 0.f;
    for (TabsItemView *view in _itemViews) {
        [view updateSize];
        allWidths += view.width;
    }
    CGFloat freeSpace = self.width - allWidths;
    CGFloat partWidth = freeSpace/(_itemViews.count-1);
    CGFloat xOffset = 0.f;
    for (TabsItemView *view in _itemViews) {
        view.xOrigin = xOffset;
        xOffset += view.width + partWidth;
    }
}

@end
