//
//  HoroscopesCell.h
//  Horoscopes
//
//  Created by Jasf on 02.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HoroscopesCell : UITableViewCell <UIPageViewControllerDelegate,
UIPageViewControllerDataSource>

@property (strong, nonatomic, nullable) NSArray *texts;
@property (strong, nonatomic, nonnull) UIPageViewController *pageViewController;
@property (strong, nonatomic, nonnull) UIViewController *parentViewController;
@property (weak, nonatomic, nullable) IBOutlet NSLayoutConstraint *heightConstraint;
@property (copy, nonatomic, nullable) void (^draggingProgress)(CGFloat completed, Direction direction);
@end
