//
//  MenuCellContentView.h
//  Horoscopes
//
//  Created by Jasf on 03.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuCellContentView : UIView
@property (nonatomic, copy, nullable) TappedBlock tappedBlock;
- (void)setTitle:(NSString *)title;
- (void)prepareForShowing;
@end
