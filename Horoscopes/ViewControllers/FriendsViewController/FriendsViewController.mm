#import "FriendsViewController.h"
#import "FriendsResultsViewController.h"
#import "UINavigationBar+Horo.h"
#import <WebKit/WebKit.h>
#import "UIImage+Horo.h"
#include "data/person.h"
#import "UIView+Horo.h"
#import "PersonObjc.h"
#import "FriendsCell.h"
#import "WebViewControllerUIDelegate.h"
#import "FriendsResultsViewController.h"
#import "FriendsHeaderView.h"
#import "UIView+TKGeometry.h"
#import "FriendsViewController+Filtering.h"

@interface FriendsViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UIScrollViewDelegate, WebViewControllerUIDelegate>

@property (nonatomic, strong) UISearchController *searchController;

// Our secondary search results table view.
@property (nonatomic, strong) FriendsResultsViewController *resultsTableController;
@property (nonatomic, strong) NSArray<PersonObjc *> *allFriends;
@property (strong, nonatomic) IBOutlet UITableViewCell *updateFriendsCell;
@property (strong, nonatomic) IBOutlet FriendsHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) UIAlertController *alertController;
@property (strong, nonatomic) PersonObjc *requestingPerson;

// For state restoration.
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
@property dispatch_block_t cancelSearchCompletion;

@end

using namespace std;
using namespace horo;

@implementation FriendsViewController
- (void)dealloc {
    [_webViewController setUIDelegate:nil];
}

- (void)viewDidLoad {
    NSCParameterAssert(_viewModel);
    NSCParameterAssert(_webViewController);
    [super viewDidLoad];
    [self updateAllFriends];
    self.navigationItem.title = L(self.navigationItem.title);
    _resultsTableController = [FriendsResultsViewController new];
    @weakify(self);
    _resultsTableController.didSelectPerson = ^(PersonObjc * person) {
        @strongify(self);
        [self didSelectPerson:person];
    };
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    _searchController.searchResultsUpdater = self;
    [_searchController.searchBar sizeToFit];
    _searchController.searchBar.backgroundImage = [[UIImage alloc] init];
    if (@available(iOS 11, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
    }
    else {
        UIView *subview = [self.searchController.searchBar horo_subviewWithClass:NSClassFromString(@"UISearchBarBackground")];
        [subview removeFromSuperview];
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    self.definesPresentationContext = YES;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.delegate = self;
    
    for (UIView *subview in self.tableView.subviews) {
        subview.backgroundColor = [UIColor clearColor];
    }
    _viewModel->friendsUpdatedCallback_ = [self_weak_](set<strong<Person>> friends){
        @strongify(self);
        [self updateAllFriends];
        [self setHeaderViewState:friends.size() ? HeaderViewSomeFriendsLoaded : HeaderViewLoadingFriends];
        [self.tableView reloadData];
    };
    _viewModel->personStateChangedCallback_ = [self_weak_](strong<Person> person) {
        @strongify(self);
        NSCParameterAssert(person.get());
        [self reloadCellWithPerson:[PersonObjc personWithPerson:person]];
    };
    _viewModel->serialRequestAlertViewControllerCallback_ = [self_weak_](strong<Person> person, bool closeAlert) {
        @strongify(self);
        if (closeAlert) {
            [self closeAlertController];
        }
        NSCParameterAssert(person.get());
        [self reloadCellWithPerson:[PersonObjc personWithPerson:person]];
        if (!closeAlert) {
            [self showAlertController:[PersonObjc personWithPerson:person]];
        }
    };
    _headerView.hidden = YES;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:L(@"cancel")
                                                                                  attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSBackgroundColorAttributeName:[UIColor clearColor],
                                                                                               NSForegroundColorAttributeName:[UIColor whiteColor] }];
    [_cancelButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [_webViewController setUIDelegate:self];
    [self.tableView addSubview:_headerView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // restore the searchController's active state
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchControllerDelegate
- (void)presentSearchController:(UISearchController *)searchController {
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    [self cleanSearchBarBackground];
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    [self cleanSearchBarBackground];
    if (_cancelSearchCompletion) {
        _cancelSearchCompletion();
        _cancelSearchCompletion = nil;
    }
}

- (void)cleanSearchBarBackground {
    UIView *view = self.tableView.subviews.firstObject;
    view.backgroundColor = [UIColor clearColor];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section] + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    _headerView.width = tableView.width;
    return (_headerView.hidden) ? nil : _headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (_headerView.hidden) ? 0.f : _headerView.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row) {
        return [super tableView:tableView
          cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1
                                                   inSection:indexPath.section]];
    }
    return self.updateFriendsCell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row) ? [super tableView:tableView
                     willSelectRowAtIndexPath:indexPath] : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonObjc *person = [self personFromCellAtIndexPath:indexPath];
    NSCAssert(person, @"person cannot be nil");
    if (!person) {
        return;
    }
    [self didSelectPerson:person];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSArray *results = [self horo_filterFriendsArray:_allFriends withString:searchController.searchBar.text];
    _resultsTableController.friends = results;
    [_resultsTableController.tableView reloadData];
    [self setTableViewVisibility:(searchController.active && searchController.searchBar.text.length)];
}

- (void)setTableViewVisibility:(BOOL)visibility {
    self.tableView.hidden = (visibility);
}

#pragma mark - Private
- (void)cancelSearchIfNeeded:(dispatch_block_t)completion {
    if (_viewModel->needsCancelSearchBeforeSegue() && _searchController.active) {
        _cancelSearchCompletion = completion;
        _searchController.active = NO;
    }
    else {
        completion();
    }
}

- (void)updateAllFriends {
    NSMutableArray *array = [NSMutableArray new];
    for (strong<Person> person : _viewModel->allFriends()) {
        PersonObjc *personObject = [[PersonObjc alloc] initWithPerson:person];
        [array addObject:personObject];
    }
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [array sortUsingDescriptors:@[descriptor]];
    _allFriends = array;
    self.friends = [_allFriends copy];
}

- (void)reloadCellWithPerson:(PersonObjc *)person {
    if (self.searchController.active) {
        [self.resultsTableController reloadCellWithPerson:person];
    }
    else {
        [super reloadCellWithPerson:person];
    }
}

- (void)setHeaderViewState:(HeaderViewStates)headerViewState {
    [_headerView setHeaderViewState:headerViewState
                    allFriendsCount:_allFriends.count];
    [self.tableView reloadData];
}

- (void)setHeaderViewHidden:(BOOL)hidden {
    _headerView.hidden = hidden;
    [self.tableView reloadData];
}

- (void)didSelectPerson:(PersonObjc *)person {
    [self cancelSearchIfNeeded:^{
        _viewModel->personSelected([person nativeRepresentation]);
    }];
}

#pragma mark - Observers
- (IBAction)menuTapped:(id)sender {
    _viewModel->menuTapped();
}

- (IBAction)cancelTapped:(id)sender {
    [self setHeaderViewState:HeaderViewStateInvisible];
    _viewModel->cancelOperation(CancelAllFriendsLoad);
}

- (IBAction)updateFriendsTapped:(id)sender {
    [self setHeaderViewState:HeaderViewStateAuthorizing];
    [self setHeaderViewHidden:NO];
    [self.tableView reloadData];
    _viewModel->updateFriendsFromFacebook();
}

#pragma mark - WebViewControllerUIDelegate
- (UIViewController *)parentViewControllerForWebViewController:(id<WebViewController>)webViewController {
    return self;
}

- (BOOL)webViewController:(id<WebViewController>)webViewController webViewDidLoad:(NSURL *)url {
    string urlString = [url.absoluteString UTF8String];
    return _viewModel->webViewDidLoad(urlString);
}

- (void)swipingToBottomFinishedInWebViewController:(id<WebViewController>)webViewController {
    [self setHeaderViewHidden:YES];
    [self.tableView reloadData];
}

- (void)webViewControllerWillCloseScreenByUser:(id<WebViewController>)webViewController {
    [self cancelTapped:nil];
}

#pragma mark - Show Alert Controller
- (void)showAlertController:(PersonObjc *)person {
    NSString *text = [NSString stringWithFormat:L(@"cancel_current_birthday_request_text"), person.name];
    _alertController = [UIAlertController alertControllerWithTitle:@"" message:text preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:L(@"yes")
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction *action) {
                                                          @strongify(self);
                                                          self.viewModel->cancelOperation(CancelFriendBirthdayLoad);
                                                      }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:L(@"no")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {}];
    [_alertController addAction:yesAction];
    [_alertController addAction:noAction];
    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (void)closeAlertController {
    if (_alertController) {
        [_alertController dismissViewControllerAnimated:YES completion:nil];
        _alertController = nil;
    }
}

@end
