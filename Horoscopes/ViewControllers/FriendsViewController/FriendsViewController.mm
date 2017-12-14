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

static NSString *const kCellIdentifier = @"cellID";
static NSString *const kTableCellNibName = @"FriendsCell";

@interface FriendsViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UIScrollViewDelegate, WebViewControllerUIDelegate>

@property (nonatomic, strong) UISearchController *searchController;

// Our secondary search results table view.
@property (nonatomic, strong) FriendsResultsViewController *resultsTableController;
@property (nonatomic, strong) NSArray<PersonObjc *> *allFriends;
@property (strong, nonatomic) IBOutlet UITableViewCell *updateFriendsCell;
@property (strong, nonatomic) IBOutlet FriendsHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

// For state restoration.
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

using namespace std;
using namespace horo;

@implementation FriendsViewController
- (void)viewDidLoad {
    NSCParameterAssert(_viewModel);
    NSCParameterAssert(_webViewController);
    [super viewDidLoad];
    [self updateAllFriends];
    self.navigationItem.title = L(self.navigationItem.title);

    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:kTableCellNibName bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    _resultsTableController = [FriendsResultsViewController new];
    //_resultsTableController.viewModel = _viewModel;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
	
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
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    for (UIView *subview in self.tableView.subviews) {
        subview.backgroundColor = [UIColor clearColor];
    }
    @weakify(self);
    _viewModel->friendsUpdatedCallback_ = [self_weak_](set<strong<Person>> friends){
        @strongify(self);
        [self updateAllFriends];
        [self setHeaderViewState: friends.size() ? HeaderViewSomeFriendsLoaded : HeaderViewLoadingFriends];
        [self.tableView reloadData];
    };
    _headerView.hidden = YES;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:L(@"cancel")
                                                                                  attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSBackgroundColorAttributeName:[UIColor clearColor],
                                                                                               NSForegroundColorAttributeName:[UIColor whiteColor] }];
    [_cancelButton setAttributedTitle:attributedString forState:UIControlStateNormal];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_webViewController setUIDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_webViewController setUIDelegate:nil];
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
}

- (void)cleanSearchBarBackground {
    UIView *view = self.tableView.subviews.firstObject;
    view.backgroundColor = [UIColor clearColor];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allFriends.count + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    _headerView.width = tableView.width;
    return (_headerView.hidden) ? nil : _headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (_headerView.hidden) ? 0.f : _headerView.height;
}

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
    [cell setName:person.name birthday:person.birthdayString imageUrl:person.imageUrl];
    cell.datasource = person;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row) ? indexPath : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSCAssert([cell isKindOfClass:[FriendsCell class]], @"cell is not friends cell");
    NSCAssert([cell.datasource isKindOfClass:[PersonObjc class]], @"datasource is not PrsonObjc");
    if (!cell || ![cell.datasource isKindOfClass:[PersonObjc class]]) {
        return;
    }
    PersonObjc *person = (PersonObjc *)cell.datasource;
    
    _viewModel->personSelected([person nativeRepresentation]);
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [_allFriends mutableCopy];
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        // name field matching
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"name"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterNoStyle;
        NSNumber *targetNumber = [numberFormatter numberFromString:searchString];
        if (targetNumber != nil) {   // searchString may not convert to a number
            lhs = [NSExpression expressionForKeyPath:@"birthday"];
            rhs = [NSExpression expressionForConstantValue:targetNumber];
            finalPredicate = [NSComparisonPredicate
                              predicateWithLeftExpression:lhs
                              rightExpression:rhs
                              modifier:NSDirectPredicateModifier
                              type:NSEqualToPredicateOperatorType
                              options:NSCaseInsensitivePredicateOption];
            [searchItemsPredicate addObject:finalPredicate];
        }
        
        // at this OR predicate to our master AND predicate
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    // match up the fields of the Product object
    NSCompoundPredicate *finalCompoundPredicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    _resultsTableController.filteredFriends = searchResults;
    [_resultsTableController.tableView reloadData];
    [self setTableViewVisibility:(searchController.active && searchText.length)];
}

- (void)setTableViewVisibility:(BOOL)visibility {
    self.tableView.hidden = (visibility);
}

#pragma mark - Private
- (void)updateAllFriends {
    NSMutableArray *array = [NSMutableArray new];
    for (strong<Person> person : _viewModel->allFriends()) {
        PersonObjc *personObject = [[PersonObjc alloc] initWithPerson:person];
        [array addObject:personObject];
    }
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [array sortUsingDescriptors:@[descriptor]];
    _allFriends = array;
}

#pragma mark - Observers
- (IBAction)menuTapped:(id)sender {
    _viewModel->menuTapped();
}

- (IBAction)cancelTapped:(id)sender {
    [self setHeaderViewState:HeaderViewStateInvisible];
    _viewModel->cancelFriendsLoadTapped();
}

- (IBAction)updateFriendsTapped:(id)sender {
    [self setHeaderViewState:HeaderViewStateAuthorizing];
    _headerView.hidden = NO;
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
    _headerView.hidden = YES;
    [self.tableView reloadData];
}

#pragma mark - Private
- (void)setHeaderViewState:(HeaderViewStates)headerViewState {
    NSDictionary *dictionary = @{@(HeaderViewStateInvisible):@(YES),
                                 @(HeaderViewStateAuthorizing):@(NO),
                                 @(HeaderViewLoadingFriends):@(NO),
                                 @(HeaderViewSomeFriendsLoaded):@(NO)};
    NSDictionary *strings = @{@(HeaderViewStateInvisible):@"",
                              @(HeaderViewStateAuthorizing):@"authorizing",
                              @(HeaderViewLoadingFriends):@"loading_friends",
                              @(HeaderViewSomeFriendsLoaded):@"%@_friends_loaded"};
    _headerView.hidden = [dictionary[@(headerViewState)] boolValue];
    NSString *text = L(strings[@(headerViewState)]);
    NSMutableAttributedString *attributedString = nil;
    
    if (headerViewState == HeaderViewSomeFriendsLoaded) {
        text = [NSString stringWithFormat:text, @(_allFriends.count)];
        attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange range = [text rangeOfString:@" "];
        NSCParameterAssert(range.location != NSNotFound);
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor greenColor]
                                 range:NSMakeRange(0, range.location)];
    }
    else {
        attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    }
    [_headerView setAttributedText:attributedString];
    [self.tableView reloadData];
}

@end
