//
//  PredictionViewController.m
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "PredictionViewController.h"
#import "Tabs.h"

static CGFloat const kRowHeight = 100;

@interface PredictionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *zodiacLabel;
@property (weak, nonatomic) IBOutlet UILabel *zodiacDateLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *zodiacTitleCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *tabsCell;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet Tabs *tabs;
@end

@implementation PredictionViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSCParameterAssert(_viewModel);
    //_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; // 20pt on top
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = kRowHeight;
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.separatorColor = [UIColor clearColor];
    
    @weakify(self);
    _viewModel->setDataFetchedCallback([self_weak_](bool success) {
        @strongify(self);
        auto titles = self.viewModel->tabsTitles();
        NSMutableArray *array = [NSMutableArray new];
        for (auto t: titles) {
            NSString *title = [NSString stringWithUTF8String:t.c_str()];
            [array addObject:title];
        }
        self.tabs.titles = [array copy];
    });
    _viewModel->didActivated();
    
    _zodiacLabel.text = [[NSString alloc] initWithUTF8String:_viewModel->zodiacName().c_str()];
    _zodiacDateLabel.text = [[NSString alloc] initWithUTF8String:_viewModel->zodiacDateString().c_str()];
    NSString *iconName = [_zodiacLabel.text lowercaseString];
    UIImage *image = [UIImage imageNamed:iconName];
    NSCAssert(image, @"image cannot be nil");
    _titleImageView.image = image;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    NSMutableArray *array = [self.navigationController.navigationBar.subviews mutableCopy];
    if (array.count) {
        [array.firstObject removeFromSuperview];
    }
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    _viewModel->tabsTitles();
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: return self.zodiacTitleCell;
        case 1: return self.tabsCell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (IBAction)menuTapped:(id)sender {
    _viewModel->menuTapped();
}

@end
