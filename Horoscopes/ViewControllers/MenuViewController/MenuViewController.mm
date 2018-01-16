//
//  MenuViewController.m
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "LGSideMenuController.h"
#import "MenuViewController.h"
#import "MenuSimpleCell.h"

typedef NS_ENUM(NSInteger, MenuRows) {
    PredictionRow,
    FriendsRow,
    AccountRow,
    NotifcationsRow,
    FeedbackRow,
    RowsCount
};

static CGFloat const kGenericOffset = 8.f;
static CGFloat const kRowHeight = 100;
static CGFloat const kHeaderViewHeight = 100.f;
static CGFloat const kHoroscopeCellBottomOffset = 20.f;
static CGFloat const kSeparatorAlpha = 0.2f;
static CGFloat const kSelectedCellBackgroundAlpha = 0.2f;

static NSString * const kMenuSimpleCell = @"menuSimpleCell";

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) MenuSimpleCell *predictionCell;
@property (strong, nonatomic) MenuSimpleCell *friendsCell;
@property (strong, nonatomic) MenuSimpleCell *accountCell;
@property (strong, nonatomic) MenuSimpleCell *notificationsCell;
@property (strong, nonatomic) MenuSimpleCell *feedbackCell;
@property (weak, nonatomic) IBOutlet UILabel *friendsDescriptionLabel;
@end

@implementation MenuViewController

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
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = kRowHeight;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:kSeparatorAlpha];
    _friendsDescriptionLabel.text = L(@"begin_update");
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuSimpleCell" bundle:nil] forCellReuseIdentifier:kMenuSimpleCell];
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
    MenuSimpleCell *cell =(MenuSimpleCell *)[tableView dequeueReusableCellWithIdentifier:kMenuSimpleCell];
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:kSelectedCellBackgroundAlpha];
    NSCParameterAssert(cell);
    NSDictionary *titles = @{@(PredictionRow):@"menu_cell_prediction",
                             @(FriendsRow):@"menu_cell_friends",
                             @(AccountRow):@"menu_cell_account",
                             @(NotifcationsRow):@"menu_cell_notifications",
                             @(FeedbackRow):@"menu_cell_feedback"};
    NSDictionary *bottomOffsets = @{@(PredictionRow) : @(kHoroscopeCellBottomOffset)};
    NSString *title = L(titles[@(indexPath.row)]);
    NSCParameterAssert(title.length);
    [cell setText:title];
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
    return UITableViewAutomaticDimension;
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

@end
