//
//  PredictionViewController.m
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "PredictionViewController.h"

static CGFloat const kRowHeight = 100;

@interface PredictionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *zodiacLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *zodiacTitleCell;
@end

@interface UINavigationBar (custom)
@end
@implementation UINavigationBar (custom)
- (void)drawRect:(CGRect)rect {}
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
    
    _viewModel->didActivated();
    
    _zodiacLabel.text = [[NSString alloc] initWithUTF8String:_viewModel->zodiacName().c_str()];
    
    const CGFloat colorMask[6] = {222, 255, 222, 255, 222, 255};
    UIImage *img = [[UIImage alloc] init];
    UIImage *maskedImage = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
  //  [self.navigationController.navigationBar setBackgroundImage:maskedImage forBarMetrics:UIBarMetricsDefault];
    //remove shadow
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    NSMutableArray *array = [self.navigationController.navigationBar.subviews mutableCopy];
    if (array.count) {
        [array.firstObject removeFromSuperview];
    }
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: return self.zodiacTitleCell;
    }
    UITableViewCell *cell = [UITableViewCell new];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)menuTapped:(id)sender {
    _viewModel->menuTapped();
}

@end
