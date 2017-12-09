//
//  FriendsViewController.m
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "FriendsResultsViewController.h"
#import "FriendsViewController.h"
#import "UINavigationBar+Horo.h"
#import <WebKit/WebKit.h>
#import "UIImage+Horo.h"
#include "data/person.h"
#import "UIView+Horo.h"
#import "PersonObjc.h"
#import "FriendsCell.h"

NSString *const kCellIdentifier = @"cellID";
NSString *const kTableCellNibName = @"FriendsCell";

/*
@interface TableView : UITableView
@end

@implementation TableView
- (void)setFrame:(CGRect)frame {
    NSLog(@"tableview set frame : %@", NSStringFromCGRect(frame));
    [super setFrame:frame];
}
@end
*/

static CGFloat const kAnimationDuration = 0.3f;
static CGFloat const kRowHeight = 100;
@interface FriendsViewController () <UITableViewDelegate, UITableViewDataSource,
WKUIDelegate, WKNavigationDelegate, UISearchResultsUpdating>
@property (strong, nonatomic) WKWebView *wkWebView;
@property (nonatomic, copy) void (^webViewDidLoadCompletion)(NSString *html, NSURL *url, NSError *error);
@property (assign, nonatomic) CGFloat maximumContentHeight;
@property (assign, nonatomic) BOOL subscribed;
@property (assign, nonatomic) BOOL needSetContentOffset;
@property (assign, nonatomic) BOOL moreFriendsRequest;
@property (strong, nonatomic) IBOutlet UITableViewCell *updateFriendsCell;
@property (strong, nonatomic) NSURL *friendsWorkingURL;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) FriendsResultsViewController *resultsTableController;
@property (strong, nonatomic) NSArray<PersonObjc *> *allFriends;
@end

@implementation FriendsViewController

using namespace std;
using namespace horo;

static FriendsViewController *staticInstance = nil;
+ (instancetype)shared {
    return staticInstance;
}

- (void)viewDidLoad {
    [self updateAllFriends];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    staticInstance = self;
    NSCParameterAssert(_viewModel);
    [super viewDidLoad];
    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.frame];
    _wkWebView.hidden = YES;
    [self.view addSubview:_wkWebView];
    [self initializeCallbacks];
    [self.tableView registerNib:[UINib nibWithNibName:kTableCellNibName bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = kRowHeight;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor clearColor];
    @weakify(self);
    _viewModel->friendsUpdatedCallback_ = [self_weak_](set<strong<Person>> friends){
        @strongify(self);
        [self.tableView reloadData];
    };
    _wkWebView.UIDelegate = self;
    _wkWebView.navigationDelegate = self;
    [self startObservingContentSizeChangesInWebView:_wkWebView];
    [self.navigationController.navigationBar horo_makeWhiteAndTransparent];
    self.tableView.backgroundColor = [UIColor redColor];
    _resultsTableController = [FriendsResultsViewController new];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_resultsTableController];
    _searchController.searchResultsUpdater = self;
    [_searchController.searchBar sizeToFit];
    _searchController.searchBar.backgroundImage = [[UIImage alloc] init];
    if (@available(iOS 11, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
    }
    else {
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    self.definesPresentationContext = YES;
    self.searchController.dimsBackgroundDuringPresentation = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupTableViewTrasparency];

}

- (void)setupTableViewTrasparency {
    self.searchController.searchResultsController.view.backgroundColor = [UIColor clearColor];
    UISearchBar *searchBar = self.searchController.searchBar;
    searchBar.backgroundColor = [UIColor clearColor];
    if ([searchBar respondsToSelector:@selector(setBarTintColor:)]) {
        searchBar.barTintColor = [UIColor clearColor];
    }
    [searchBar
     setBackgroundImage:[UIImage horo_strechableImageWithTopPixelColor:[UIColor colorWithWhite:1.0 alpha:0.08]]];
    UIView *backgroundView = (UIView *)[searchBar horo_subviewWithClass:NSClassFromString(@"UISearchBarBackground")];
    backgroundView.alpha = 0.f;
    self.tableView.backgroundView = backgroundView;
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _wkWebView.frame = self.view.bounds;
}

- (void)initializeCallbacks {
    @weakify(self);
    _viewModel->authorizationUrlCallback_ = [self_weak_](std::string url, std::vector<std::string> allowedPatterns) {
        @strongify(self);
        NSString *urlString = [[NSString alloc] initWithUTF8String:url.c_str()];
        [self showUrl:urlString];
    };
}

- (void)showUrl:(NSString *)urlString {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [_wkWebView loadRequest:request];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.updateFriendsCell;
    }
    NSInteger index = indexPath.row - 1;
    NSCAssert(index < _allFriends.count, @"index out of bounds");
    if (index >= _allFriends.count) {
        return [UITableViewCell new];
    }
    
    PersonObjc *person = _allFriends[index];
    
    FriendsCell *cell = (FriendsCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    [cell setName:person.name birthday:person.birthday];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return;
    }
    NSInteger index = indexPath.row - 1;
    _viewModel->friendWithIndexSelected((int)index);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allFriends.count;
}

#pragma mark - Observer
- (IBAction)friendsTapped:(id)sender {
    //_viewModel->friendsTapped();
}
- (IBAction)zodiacsTapped:(id)sender {
    //_viewModel->zodiacsTapped();
}


- (void)swipeToBottom {
    dispatch_block_t block = ^{
        CGPoint point = CGPointMake(0, self.wkWebView.scrollView.contentSize.height);
        if (point.y < 0.f) {
            point.y = 0;
        }
        [self.wkWebView.scrollView setContentOffset:point animated:YES];
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

#pragma mark - Observers
- (IBAction)updateFriendsTapped:(id)sender {
    _viewModel->updateFriendsFromFacebook();
}

- (IBAction)menuTapped:(id)sender {
    _viewModel->menuTapped();
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"ci: %@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
    if (@available(iOS 11, *)) {
        UITextField *textField = [_searchController.searchBar valueForKey:@"searchField"];
        textField.textColor = [UIColor whiteColor];
    }
    if (!_resultsTableController.filteredFriends.count) {
        _resultsTableController.filteredFriends = [_allFriends copy];
    }
    [_resultsTableController.tableView reloadData];
    self.tableView.contentInset = UIEdgeInsetsZero;
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         [self changeTableViewVisibility:(searchController.active && searchController.searchBar.text.length)];
    }];
}

#pragma mark - Private Methods
- (void)changeTableViewVisibility:(BOOL)searchControllerActive {
    self.tableView.alpha = (searchControllerActive) ? 0.f : 1.f;
}

- (void)updateAllFriends {
    NSMutableArray *array = [NSMutableArray new];
    for (strong<Person> person : _viewModel->allFriends()) {
        PersonObjc *personObject = [[PersonObjc alloc] initWithPerson:person];
        [array addObject:personObject];
    }
    _allFriends = array;
}
// огромный класс! нужно разнести

@end
