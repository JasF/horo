//
//  ZodiacsLayoutController.m
//  Horoscopes
//
//  Created by Jasf on 21.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "ZodiacsLayoutController.h"
#import "MenuZodiacCell.h"

static NSInteger const kNumberOfSections = 6; // number of lines
static NSInteger const kNumberOfItemsInSection = 2; // number of columns

static NSInteger const kNumberOfSectionsPlus = 4;
static NSInteger const kNumberOfItemsInSectionPlus = 3;

static NSString * const kZodiacCellNibName = @"kZodiacCellNibName";
static CGFloat const kItemHeight = 80.f;
static CGFloat const kIphonePlusWidth = 375.f;

@interface ZodiacsLayoutController () <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSArray *items;
@end

@implementation ZodiacsLayoutController

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.width/[self numberOfZodiacsPerLine], self.view.height/[self numberOfLines]);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

#pragma mark - Inititalization
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MenuZodiacCell" bundle:nil] forCellWithReuseIdentifier:kZodiacCellNibName];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self numberOfLines];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfZodiacsPerLine];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MenuZodiacCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZodiacCellNibName forIndexPath:indexPath];
    NSInteger index = indexPath.section * kNumberOfItemsInSection + indexPath.row;
    NSCAssert(index < _items.count, @"incorrect indexPath: %@", indexPath);
    if (index >= _items.count) {
        return cell;
    }
    @weakify(self);
    cell.tappedBlock = ^(NSString *zodiacName) {
        @strongify(self);
        [self didSelectZodiacWithName:zodiacName];
    };
    NSDictionary *dictionary = _items[index];
    NSString *name = dictionary[@"name"];
    NSString *imageName = [dictionary[@"imageName"] lowercaseString];
    UIImage *zodiacImage = [UIImage imageNamed:imageName];
    NSCAssert(zodiacImage, @"zodiacImage for name: %@ must exists", imageName);
    [cell setImage:zodiacImage zodiacName:name];
    return cell;
}

#pragma mark - Accessors
- (void)setItems:(NSArray *)items {
    _items = items;
}

- (NSInteger)preferredItemHeight {
    return kItemHeight;
}

#pragma mark - Private Methods
- (NSInteger)numberOfLines {
    return ([self isPlus]) ? kNumberOfSectionsPlus : kNumberOfSections;
}

- (NSInteger)numberOfZodiacsPerLine {
    return ([self isPlus]) ? kNumberOfItemsInSectionPlus : kNumberOfItemsInSection;
}

- (void)didSelectZodiacWithName:(NSString *)zodiacName {
    for (NSDictionary *dict in _items) {
        if ([dict[@"name"] isEqualToString:zodiacName]) {
            NSInteger index = [_items indexOfObject:dict];
            if (_tappedBlock) {
                _tappedBlock(index);
            }
            break;
        }
    }
}

- (BOOL)isPlus {
    return !!([UIScreen mainScreen].bounds.size.width >= kIphonePlusWidth);
}

@end
