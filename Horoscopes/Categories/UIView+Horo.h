//
//  UIView+Horo.h
//  Horoscopes
//
//  Created by Jasf on 02.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Horo)
- (void)horo_addFillingSubview:(UIView *)subview;
- (UIImage *)horo_grabImage;
- (id)horo_subviewWithClass:(Class)classForSearch;
@end
