//
//  PredictionViewController.m
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "PredictionViewController.h"
#import "UINavigationBar+Horo.h"
#import "HoroscopesCell.h"
#import "NSString+Horo.h"
#import "UIView+Horo.h"
#import "Tabs.h"

#ifdef CENSORED
#import "Horoscopes_censored-Swift.h"
#else
#import "Horoscopes-Swift.h"
#endif

static CGFloat const kAcitivityIndicatorColorAlpha = 0.8f;
typedef NS_ENUM(NSInteger, PredictionSections) {
    MainSection,
    SectionsCount
};

typedef NS_ENUM(NSInteger, PredictionRows) {
    TitleRow,
    TabsRow,
    PredictionRow,
    RowsCount
};

typedef NS_ENUM(NSInteger, NoConnectionRows) {
    NoConnectionTitleRow,
    NoConnectionRow,
    NoConnectionRowsCount
};

static CGFloat const kTitleRowHeight = 106.f;
static CGFloat const kTabsRowHeight = 48.f;
static CGFloat const kNoConnectionRowHeight = 62.f;
static CGFloat const kPredictionRowAddedHeight = 12.f;
static NSInteger const kTodayTabIndex = 1;
static CGFloat const kActivityIndicatorSize = 50.f;

@interface PredictionViewController () <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *zodiacLabel;
@property (weak, nonatomic) IBOutlet UILabel *zodiacDateLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *zodiacTitleCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *tabsCell;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet Tabs *tabs;
@property (strong, nonatomic) IBOutlet HoroscopesCell *horoscopesCell;
@property (weak, nonatomic) IBOutlet UIView *horoscopesContainerView;
@property (assign, nonatomic) BOOL allowCustomAnimationWithTabs;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (assign, nonatomic) BOOL showNoConnectionView;
@property (weak, nonatomic) IBOutlet UILabel *networkErrorLabel;
@property (weak, nonatomic) IBOutlet UIButton *networkErrorButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *noConnectionCell;

@end

@implementation PredictionViewController

- (void)setViewModel:(strong<horo::PredictionScreenViewModel>)viewModel {
    _viewModel = viewModel;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allowCustomAnimationWithTabs = YES;
    NSCParameterAssert(_viewModel);
    NSCParameterAssert(_horoscopesPageViewController);
    [self initializeHoroscopeCell];
    [self initializeTabs];
    _horoscopesPageViewController.view.frame = self.view.frame;
    [self addChildViewController:_horoscopesPageViewController];
    [_horoscopesContainerView horo_addFillingSubview:_horoscopesPageViewController.view];
    [_horoscopesPageViewController didMoveToParentViewController:self];
    
    _networkErrorLabel.text = L(_networkErrorLabel.text);
    
    NSMutableAttributedString *attributedString = [[_networkErrorButton attributedTitleForState:UIControlStateNormal] mutableCopy];
    [attributedString replaceCharactersInRange:NSMakeRange(0, attributedString.string.length) withString:L(attributedString.string)];
    [_networkErrorButton setAttributedTitle:attributedString
                                   forState:UIControlStateNormal];
    
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.allowsSelection = NO;
                                              
    @weakify(self);
    [self showProgressHUD];
    _viewModel->setDataFetchedCallback([self_weak_](bool success) {
        @strongify(self);
        [self hideProgressHUD];
        NSMutableArray *localizedStrings = [NSMutableArray new];
        auto titles = self.viewModel->tabsTitles();
        if (!titles.size()) {
            self.showNoConnectionView = YES;
            [self.tableView reloadData];
            return;
        }
        for (NSString *string in [NSString horo_stringsArrayWithList:titles]) {
            [localizedStrings addObject:L(string)];
        }
        self.tabs.titles = localizedStrings;
        self.horoscopesCell.texts = [NSString horo_stringsArrayWithList:self.viewModel->horoscopesText()];
        [self updatePredictionHeight:YES];
        if (self.tabs.titles.count > kTodayTabIndex) {
            [self.tabs setItemSelected:kTodayTabIndex
                             animation:TabsAnimationNone
                            withNotify:NO];
        }
    });
    _viewModel->didActivated();
    
    NSString *zodiacName = L([NSString stringWithUTF8String:_viewModel->zodiacName().c_str()]);
    _zodiacLabel.text = zodiacName;
    _zodiacDateLabel.text = L([NSString stringWithUTF8String:_viewModel->zodiacDateString().c_str()]);
    NSString *iconName = [zodiacName lowercaseString];
    UIImage *image = [UIImage imageNamed:iconName];
    NSCAssert(image, @"image cannot be nil");
    _titleImageView.image = image;
    [self.navigationController.navigationBar horo_makeWhiteAndTransparent];
    
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
    return (_showNoConnectionView) ? NoConnectionRowsCount : RowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_showNoConnectionView) {
        switch (indexPath.row) {
            case NoConnectionTitleRow: return self.zodiacTitleCell;
            case NoConnectionRow: return self.noConnectionCell;
        }
    }
    else {
        switch (indexPath.row) {
            case TitleRow: return self.zodiacTitleCell;
            case TabsRow: return self.tabsCell;
            case PredictionRow: return self.horoscopesCell;
        }
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = @{@(TitleRow):^CGFloat{return kTitleRowHeight;},
                                 @(TabsRow):^CGFloat{return kTabsRowHeight;},
                                 @(PredictionRow):^CGFloat{return [_horoscopesCell getHeight] + kPredictionRowAddedHeight;}};
    
    if (_showNoConnectionView) {
        dictionary = @{@(NoConnectionTitleRow):^CGFloat{return kTitleRowHeight;},
                       @(NoConnectionRow):^CGFloat{return kNoConnectionRowHeight;}};
    }
    
    CGFloat (^heightBlock)() = dictionary[@(indexPath.row)];
    NSCAssert(heightBlock, @"Unknown cell: %@", indexPath);
    if (!heightBlock) {
        return 0.f;
    }
    return heightBlock();
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (IBAction)menuTapped:(id)sender {
    _viewModel->menuTapped();
}

#pragma mark - Private Methods {
- (void)initializeHoroscopeCell {
    _horoscopesCell.parentViewController = self;
    _horoscopesCell.pageViewController = _horoscopesPageViewController;
    @weakify(self);
    _horoscopesCell.draggingProgress = ^(CGFloat completed, Direction direction) {
        @strongify(self);
        if (self.allowCustomAnimationWithTabs) {
            [self.tabs animateSelection:direction patchCompleted:completed];
        }
    };
    _horoscopesCell.selectedPageChanged = ^(NSInteger previous, NSInteger current) {
        @strongify(self);
        [self.tabs setItemSelected:current animation:TabsAnimationFrameOnly];
        [self updatePredictionHeight:NO];
    };
}

- (void)initializeTabs {
    @weakify(self);
    _tabs.tabsItemViewSelected = ^(NSInteger previousIndex, NSInteger currentIndex) {
        @strongify(self);
        self.allowCustomAnimationWithTabs = NO;
        [self.horoscopesCell setSelectedIndex:currentIndex
                                   completion:^{
            @strongify(self);
            self.allowCustomAnimationWithTabs = YES;
            [self updatePredictionHeight:YES];
        }];
    };
}

- (void)updatePredictionHeight:(BOOL)force {
    if (force) {
        [self performReloadData];
        return;
    }
    if (self.horoscopesCell.scrollView.decelerating) {
        @weakify(self);
        self.horoscopesCell.didEndDeceleratingBlock = ^{
            @strongify(self);
            self.horoscopesCell.didEndDeceleratingBlock = nil;
            [self performReloadData];
        };
    }
    else {
        [self performReloadData];
    }
}

- (void)performReloadData {
    /* dispatch_async is fixing Page View Controller Assertion Issue Inside HoroscopesCell
     https://stackoverflow.com/questions/24000712/pageviewcontroller-setviewcontrollers-crashes-with-invalid-parameter-not-satisf
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        [_horoscopesCell updateHeight];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    });
}

#pragma mark - Private Methods
- (void)showProgressHUD {
    NVActivityIndicatorView *activityIndicator = [[NVActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, kActivityIndicatorSize, kActivityIndicatorSize)];
    activityIndicator.color = [[UIColor whiteColor] colorWithAlphaComponent:kAcitivityIndicatorColorAlpha];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.customView = activityIndicator;
    [activityIndicator startAnimating];
}

- (void)hideProgressHUD {
    [_hud hideAnimated:YES];
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    NVActivityIndicatorView *indicator = (NVActivityIndicatorView *)hud.customView;
    [indicator stopAnimating];
    indicator.hidden = YES;
}

#pragma mark - Observers

- (IBAction)noConnectionTapped:(id)sender {
    _showNoConnectionView = NO;
    [self.tableView reloadData];
    [self showProgressHUD];
    _viewModel->noConnectionTapped();
}
@end
