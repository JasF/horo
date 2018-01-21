//
//  ZodiacsLayoutController.h
//  Horoscopes
//
//  Created by Jasf on 21.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZodiacsLayoutController : UICollectionViewController <UICollectionViewDelegateFlowLayout>
@property (copy, nonatomic) void (^tappedBlock)(NSInteger zodiacIndex);
- (void)setItems:(NSArray *)items;
- (NSInteger)numberOfZodiacsPerLine;
- (NSInteger)numberOfLines;
- (NSInteger)preferredItemHeight;
@end
