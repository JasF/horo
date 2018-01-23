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
#import "UIColor+Horo.h"
#import "UIView+Horo.h"
#import "FriendCell.h"
#import "Tabs.h"

#ifdef CENSORED
#import "Horoscopes_censored-Swift.h"
#else
#import "Horoscopes-Swift.h"
#endif

using namespace std;
using namespace horo;

typedef NS_ENUM(NSInteger, PredictionSections) {
    MainSection,
    SectionsCount
};

typedef NS_ENUM(NSInteger, PredictionRows) {
    FriendRow,
    TitleRow,
    TabsRow,
    PredictionRow,
    RowsCount
};

typedef NS_ENUM(NSInteger, NoConnectionRows) {
    NoConnectionFriendRow,
    NoConnectionTitleRow,
    NoConnectionRow,
    NoConnectionRowsCount
};

static CGFloat const kAcitivityIndicatorColorAlpha = 0.8f;
static CGFloat const kTitleRowHeight = 106.f;
static CGFloat const kTabsRowHeight = 48.f;
static CGFloat const kNoConnectionRowHeight = 62.f;
static CGFloat const kPredictionRowAddedHeight = 12.f;
static NSInteger const kTodayTabIndex = 1;
static CGFloat const kActivityIndicatorSize = 50.f;
static CGFloat const kFriendCellHeight = 65.f;

@interface PredictionViewController () <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate>
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
@property (strong, nonatomic) IBOutlet FriendCell *friendCell;

@end

@implementation PredictionViewController

- (void)setViewModel:(strong<horo::PredictionScreenViewModel>)viewModel {
    _viewModel = viewModel;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    
}

- (void)viewDidLoad {
    NSCParameterAssert(_viewModel);
    NSCParameterAssert(_horoscopesPageViewController);
    [super viewDidLoad];
    self.allowCustomAnimationWithTabs = YES;
    [self initializeHoroscopeCell];
    [self initializeTabs];
    if (_viewModel->personExists()) {
        @weakify(self);
        _viewModel->personData([self_weak_](string imageUrl, string name, string birthday) {
            @strongify(self);
            [self.friendCell setImageURL:[NSURL URLWithString:[NSString stringWithUTF8String:imageUrl.c_str()]]
                                    name:[NSString stringWithUTF8String:name.c_str()]
                                birthday:[NSString stringWithUTF8String:birthday.c_str()]];
        });
    }
    _horoscopesPageViewController.view.frame = self.view.frame;
    [self addChildViewController:_horoscopesPageViewController];
    [_horoscopesContainerView horo_addFillingSubview:_horoscopesPageViewController.view];
    [_horoscopesPageViewController didMoveToParentViewController:self];
    
    _networkErrorLabel.text = L(_networkErrorLabel.text);
    
    NSMutableAttributedString *attributedString = [[_networkErrorButton attributedTitleForState:UIControlStateNormal] mutableCopy];
    [attributedString replaceCharactersInRange:NSMakeRange(0, attributedString.string.length) withString:L(attributedString.string)];
    [_networkErrorButton setAttributedTitle:attributedString
                                   forState:UIControlStateNormal];
    
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.allowsSelection = NO;
    
    if (_viewModel->backgroundWithSolidColor()) {
        self.view.backgroundColor = [UIColor horo_fromColor:_viewModel->backgroundColor()];
        [_horoscopesCell setBackgroundColor:[UIColor horo_fromColor:_viewModel->backgroundColor()]];
    }
    [_horoscopesCell setTextColor:[UIColor horo_fromColor:_viewModel->fontColor()]];
                                              
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
    NSString *iconName = [NSString stringWithUTF8String:_viewModel->zodiacName().c_str()];
    UIImage *image = [UIImage imageNamed:iconName];
    NSCAssert(image, @"image cannot be nil");
    _titleImageView.image = image;
    _viewModel->tabsTitles();
    if (_hideMenuButton) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    else {
        if (@available (iOS 11, *)) {
            self.navigationController.navigationBar.prefersLargeTitles = NO;
        }
    }
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
            case NoConnectionFriendRow: return self.friendCell;
            case NoConnectionTitleRow: return self.zodiacTitleCell;
            case NoConnectionRow: return self.noConnectionCell;
        }
    }
    else {
        switch (indexPath.row) {
            case FriendRow: return self.friendCell;
            case TitleRow: return self.zodiacTitleCell;
            case TabsRow: return self.tabsCell;
            case PredictionRow: return self.horoscopesCell;
        }
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = @{@(FriendRow):^CGFloat{return _viewModel->personExists() ? kFriendCellHeight : 0.f;},
                                 @(TitleRow):^CGFloat{return kTitleRowHeight;},
                                 @(TabsRow):^CGFloat{return kTabsRowHeight;},
                                 @(PredictionRow):^CGFloat{return [_horoscopesCell getHeight] + kPredictionRowAddedHeight;}};
    
    if (_showNoConnectionView) {
        dictionary = @{@(NoConnectionFriendRow):^CGFloat{return _viewModel->personExists() ? kFriendCellHeight : 0.f;},
                       @(NoConnectionTitleRow):^CGFloat{return kTitleRowHeight;},
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
