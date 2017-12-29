//
//  NotificationsViewController.m
//  Horoscopes
//
//  Created by Jasf on 23.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "NotificationsViewController.h"
#import "SettingsCell.h"

static CGFloat const kTableTopInset = 20.f;

typedef NS_ENUM(NSInteger, RowsCount) {
    EnablePushesRow,
    PushTimeRow,
    PushesRowsCount
};

@interface NotificationsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet SettingsCell *enablePushesCell;
@property (strong, nonatomic) IBOutlet SettingsCell *pushTimeCell;

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    NSCParameterAssert(_viewModel.get());
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    for (SettingsCell *cell in [self cellsDictionary].allValues) {
        [cell setText:L(cell.text)];
    }
    _tableView.contentInset = UIEdgeInsetsMake(kTableTopInset, 0, 0, 0);
    _enablePushesCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.navigationItem.title = L(@"notifications");
}

- (void)dealloc {
    _viewModel->sendSettingsIfNeeded();
}

- (IBAction)menuTapped:(id)sender {
    _viewModel->menuTapped();
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return PushesRowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = [self cellsDictionary];
    UITableViewCell *cell = dictionary[@(indexPath.row)];
    NSCAssert(cell, @"Cell for indexPath: %@ not found", indexPath);
    if (!cell) {
        return [UITableViewCell new];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = @{@(PushTimeRow):indexPath};
    NSIndexPath *result = dictionary[@(indexPath.row)];
    return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == PushTimeRow) {
        _viewModel->pushTimeTapped();
    }
}

#pragma mark - Private Methods
- (NSDictionary *)cellsDictionary {
    NSDictionary *dictionary = @{@(EnablePushesRow):_enablePushesCell, @(PushTimeRow):_pushTimeCell};
    return dictionary;
}

#pragma mark - Observers
- (IBAction)enablePushSwitchChanged:(id)sender {
    
}

@end
