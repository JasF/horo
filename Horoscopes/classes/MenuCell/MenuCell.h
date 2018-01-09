//
//  MenuCell.h
//  Horoscopes
//
//  Created by Jasf on 07.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuCell : UITableViewCell
@property (nonatomic, copy, nullable) TappedBlock tappedBlock;
- (void)setTitle:(NSString *)title;
@end
