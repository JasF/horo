//
//  MenuSimpleCell.h
//  Horoscopes
//
//  Created by Jasf on 16.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuSimpleCell;
@protocol MenuSimpleCellDelegate <NSObject>
- (void)menuSimpleCell:(MenuSimpleCell *)cell didTappedOnZodiacButton:(BOOL)leftButton;
@end

@interface MenuSimpleCell : UITableViewCell
@property (weak, nonatomic) id<MenuSimpleCellDelegate> delegate;
- (void)setText:(NSString *)text;
- (void)setLeftText:(NSString *)leftText rightText:(NSString *)rightText;
- (void)setOffset:(CGFloat)bottomOffset;
@end
