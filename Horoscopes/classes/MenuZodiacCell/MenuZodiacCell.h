//
//  MenuZodiacCell.h
//  Horoscopes
//
//  Created by Jasf on 20.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuZodiacCell : UICollectionViewCell
@property (copy, nonatomic) void (^tappedBlock)(NSString *zodiacName);
- (void)setImage:(UIImage *)image zodiacName:(NSString *)zodiacName;
@end
