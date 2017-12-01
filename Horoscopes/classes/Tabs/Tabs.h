//
//  Tabs.h
//  Horoscopes
//
//  Created by Jasf on 29.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tabs : UIView
@property (nonatomic) NSArray *titles;
- (void)setItemSelected:(NSInteger)itemIndex animated:(BOOL)animated;
@end
