//
//  ZodiacsCell.m
//  Horoscopes
//
//  Created by Jasf on 20.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "MenuZodiacCell.h"
#import "ZodiacsCell.h"

static NSInteger const kNumberOfSections = 4; // number of lines
static NSInteger const kNumberOfItemsInSection = 3; // number of columns
static NSString * const kZodiacCellNibName = @"kZodiacCellNibName";

@interface ZodiacsCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *items;
@end

@implementation ZodiacsCell

#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];
    [_collectionView registerNib:[UINib nibWithNibName:@"MenuZodiacCell" bundle:nil] forCellWithReuseIdentifier:kZodiacCellNibName];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - UICollectionViewDelegate
/*
-(CGSize) collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size;
}
*/

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return kNumberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kNumberOfItemsInSection;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MenuZodiacCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZodiacCellNibName forIndexPath:indexPath];
    NSInteger index = indexPath.section * kNumberOfItemsInSection + indexPath.row;
    NSCAssert(index < _items.count, @"incorrect indexPath: %@", indexPath);
    if (index >= _items.count) {
        return cell;
    }
    NSDictionary *dictionary = _items[index];
    NSString *name = dictionary[@"name"];
    NSString *imageName = [dictionary[@"imageName"] lowercaseString];
    UIImage *zodiacImage = [UIImage imageNamed:imageName];
    NSCAssert(zodiacImage, @"zodiacImage for name: %@ must exists", imageName);
    [cell setImage:zodiacImage title:name];
    return cell;
}

#pragma mark - Public Methods
- (void)setItems:(NSArray *)items {
    _items = items;
    NSCAssert(items.count == 12, @"incorrect number of items");
}

@end
