//
//  MenuViewController.m
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"

typedef NS_ENUM(NSInteger, MenuRows) {
    CloseRow,
    FriendsRow,
    AccountRow,
    NotifcationsRow,
    FeedbackRow,
    RowsCount
};

static CGFloat const kRowHeight = 100;

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableViewCell *closeCell;
@property (strong, nonatomic) IBOutlet MenuCell *friendsCell;
@property (strong, nonatomic) IBOutlet MenuCell *accountCell;
@property (strong, nonatomic) IBOutlet MenuCell *notificationsCell;
@property (strong, nonatomic) IBOutlet MenuCell *feedbackCell;
@property (weak, nonatomic) IBOutlet UILabel *friendsDescriptionLabel;
@end

@implementation MenuViewController

- (void)injectViewModel:(NSValue *)viewModelValue {
    strong<horo::MenuScreenViewModel> *viewModel =(strong<horo::MenuScreenViewModel> * )[viewModelValue pointerValue];
    _viewModel = *viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSCParameterAssert(_viewModel);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = kRowHeight;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.allowsSelection = NO;
    _friendsDescriptionLabel.text = L(@"begin_update");
    @weakify(self);
    [_friendsCell setTitle:L(@"menu_cell_friends")];
    _friendsCell.tappedBlock = ^BOOL{
        @strongify(self);
        self.viewModel->friendsTapped();
        return YES;
    };
    [_accountCell setTitle:L(@"menu_cell_account")];
    _accountCell.tappedBlock = ^BOOL{
        @strongify(self);
        self.viewModel->accountTapped();
        return YES;
    };
    [_notificationsCell setTitle:L(@"menu_cell_notifications")];
    _notificationsCell.tappedBlock = ^BOOL{
        @strongify(self);
        self.viewModel->notificationsTapped();
        return NO;
    };
    [_feedbackCell setTitle:L(@"menu_cell_feedback")];
    _feedbackCell.tappedBlock = ^BOOL{
        @strongify(self);
        self.viewModel->feedbackTapped();
        return NO;
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case CloseRow: return self.closeCell;
        case FriendsRow: return self.friendsCell;
        case AccountRow: return self.accountCell;
        case NotifcationsRow: return self.notificationsCell;
        case FeedbackRow: return self.feedbackCell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(MenuCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[MenuCell class]]) {
       // [cell prepareForShowing];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return RowsCount;
}

#pragma mark - Observer
- (IBAction)friendsTapped:(id)sender {
    [self hideMenu];
    _viewModel->friendsTapped();
}

- (IBAction)zodiacsTapped:(id)sender {
    [self hideMenu];
    _viewModel->zodiacsTapped();
}

- (IBAction)closeTapped:(id)sender {
    [self hideMenu];
    _viewModel->closeTapped();
}

#pragma mark - Private Methods
- (void)hideMenu {
    _viewModel->hideMenu();
    //[mainViewController hideLeftViewAnimated:YES completionHandler:nil];
}

@end
