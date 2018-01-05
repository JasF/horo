//
//  PredictionViewController.m
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "PredictionViewController.h"
#import "UINavigationBar+Horo.h"
#import "HoroscopesCell.h"
#import "NSString+Horo.h"
#import "UIView+Horo.h"
#import "Tabs.h"

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

static CGFloat const kTitleRowHeight = 106.f;
static CGFloat const kTabsRowHeight = 48.f;
static CGFloat const kPredictionRowAddedHeight = 12.f;
static NSInteger const kTodayTabIndex = 1;

@interface PredictionViewController () <UITableViewDelegate, UITableViewDataSource>
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
    
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.allowsSelection = NO;
    
    @weakify(self);
    _viewModel->setDataFetchedCallback([self_weak_](bool success) {
        @strongify(self);
        NSMutableArray *localizedStrings = [NSMutableArray new];
        for (NSString *string in [NSString horo_stringsArrayWithList:self.viewModel->tabsTitles()]) {
            [localizedStrings addObject:L(string)];
        }
        self.tabs.titles = localizedStrings;
        self.horoscopesCell.texts = [NSString horo_stringsArrayWithList:self.viewModel->horoscopesText()];
        [self updatePredictionHeight];
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
    return RowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case TitleRow: return self.zodiacTitleCell;
        case TabsRow: return self.tabsCell;
        case PredictionRow: return self.horoscopesCell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = @{@(TitleRow):^CGFloat{return kTitleRowHeight;},
                                 @(TabsRow):^CGFloat{return kTabsRowHeight;},
                                 @(PredictionRow):^CGFloat{return [_horoscopesCell getHeight] + kPredictionRowAddedHeight;}};
    
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
        [self updatePredictionHeight];
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
            [self updatePredictionHeight];
        }];
    };
}

- (void)updatePredictionHeight {
    // dispatch_async is fixing Page View Controller Assertion Issue Inside HoroscopesCell https://stackoverflow.com/questions/24000712/pageviewcontroller-setviewcontrollers-crashes-with-invalid-parameter-not-satisf
    dispatch_async(dispatch_get_main_queue(), ^{
        [_horoscopesCell updateHeight];
      //  [self.tableView reloadData];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    });
}

@end
