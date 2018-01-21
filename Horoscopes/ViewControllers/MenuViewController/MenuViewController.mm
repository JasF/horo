//
//  MenuViewController.m
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "LGSideMenuController.h"
#import "NSDictionary+Horo.h"
#import "MenuViewController.h"
#import "MenuSimpleCell.h"
#import "ZodiacsCell.h"

typedef NS_ENUM(NSInteger, MenuRows) {
    PredictionRow,
    ZodiacsRow,
    FriendsRow,
    AccountRow,
    NotifcationsRow,
    FeedbackRow,
    RowsCount
};

using namespace std;
using namespace horo;

static CGFloat const kGenericOffset = 8.f;
static CGFloat const kHoroscopeCellBottomOffset = 8.f;

static CGFloat const kRowHeight = 40.f;
static CGFloat const kHeaderViewHeight = 20.f;
// static CGFloat const kSeparatorAlpha = 0.2f;

static CGFloat const kZodiacsRowHeight = 200.f;

static NSString * const kMenuSimpleCell = @"menuSimpleCell";
static NSString * const kZodiacsCell = @"zodiacsCell";

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource, MenuSimpleCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *friendsDescriptionLabel;
@end

@implementation MenuViewController {
    NSIndexPath *_selectedIndexPath;
}

- (void)injectViewModel:(NSValue *)viewModelValue {
    strong<horo::MenuScreenViewModel> *viewModel =(strong<horo::MenuScreenViewModel> * )[viewModelValue pointerValue];
    _viewModel = *viewModel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSCParameterAssert(_viewModel);
    _friendsDescriptionLabel.text = L(@"begin_update");
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuSimpleCell" bundle:nil] forCellReuseIdentifier:kMenuSimpleCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZodiacsCell" bundle:nil] forCellReuseIdentifier:kZodiacsCell];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHide:) name:LGSideMenuDidHideLeftViewNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return RowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuSimpleCell *cell = nil;
    cell.delegate = self;
    if (indexPath.row == ZodiacsRow) {
        ZodiacsCell *zodiacsCell = [tableView dequeueReusableCellWithIdentifier:kZodiacsCell];
        auto zodiacs = _viewModel->zodiacsTitlesAndImageNames();
        NSMutableArray *zodiacsArray = [NSMutableArray new];
        for (dictionary dict : zodiacs) {
            NSDictionary *dictionary = [NSDictionary horo_dictionaryFromJsonValue:dict];
            [zodiacsArray addObject:dictionary];
        }
        [zodiacsCell setItems:[zodiacsArray copy]];
        return zodiacsCell;
        /*
        _viewModel->dataForZodiacRow((int)zodiacRowIndex, [cell](string leftZodiacName, string rightZodiacName){
            [cell setLeftText:L([NSString stringWithUTF8String:leftZodiacName.c_str()])
                    rightText:L([NSString stringWithUTF8String:rightZodiacName.c_str()])];
        });
         */
    }
    else {
        cell =(MenuSimpleCell *)[tableView dequeueReusableCellWithIdentifier:kMenuSimpleCell];
        NSCParameterAssert(cell);
        NSDictionary *titles = @{@(PredictionRow):@"menu_cell_prediction",
                                 @(FriendsRow):@"menu_cell_friends",
                                 @(AccountRow):@"menu_cell_account",
                                 @(NotifcationsRow):@"menu_cell_notifications",
                                 @(FeedbackRow):@"menu_cell_feedback"};
        NSString *title = L(titles[@(indexPath.row)]);
        NSCParameterAssert(title.length);
        [cell setText:title];
    }
    NSDictionary *bottomOffsets = @{@(PredictionRow) : @(kHoroscopeCellBottomOffset)};
    NSNumber *value = bottomOffsets[@(indexPath.row)];
    CGFloat offset = (value) ? value.floatValue : kGenericOffset;
    [cell setOffset:offset];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeaderViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ZodiacsRow) {
        return kZodiacsRowHeight;
    }
    return kRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case PredictionRow:
            _viewModel->closeTapped();
            break;
        case FriendsRow:
            _viewModel->friendsTapped();
            break;
        case AccountRow:
            _viewModel->accountTapped();
            break;
        case NotifcationsRow:
            _viewModel->notificationsTapped();
            break;
        case FeedbackRow:
            _viewModel->feedbackTapped();
            break;
    }
}

#pragma mark - Observers
- (void)menuDidHide:(id)sender {
    [self.tableView reloadData];
}

#pragma mark - MenuSimpleCellDelegate
- (void)menuSimpleCell:(MenuSimpleCell *)cell didTappedOnZodiacButton:(BOOL)leftButton {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSCAssert(indexPath, @"indexPath must be exists");
    if (!indexPath) {
        return;
    }
    _selectedIndexPath = indexPath;
    //_viewModel->didSelectZodiac((int)indexPath.row - ZodiacsRow1, leftButton);
}

@end
