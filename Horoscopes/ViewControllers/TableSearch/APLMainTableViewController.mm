/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The application's primary table view controller showing a list of products.
 */

#import "APLMainTableViewController.h"
#import "APLDetailViewController.h"
#import "APLResultsTableController.h"
#import "APLProduct.h"
#import "FriendsResultsViewController.h"
#import "FriendsViewController.h"
#import "UINavigationBar+Horo.h"
#import <WebKit/WebKit.h>
#import "UIImage+Horo.h"
#include "data/person.h"
#import "UIView+Horo.h"
#import "PersonObjc.h"
#import "FriendsCell.h"

@interface APLMainTableViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;

// Our secondary search results table view.
@property (nonatomic, strong) APLResultsTableController *resultsTableController;
@property (nonatomic, strong) NSArray<PersonObjc *> *allFriends;
@property (strong, nonatomic) IBOutlet UITableViewCell *updateFriendsCell;

// For state restoration.
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

using namespace std;
using namespace horo;

#pragma mark -

@implementation APLMainTableViewController
- (void)viewDidLoad {
	[super viewDidLoad];
    [self updateAllFriends];

    _resultsTableController = [[APLResultsTableController alloc] init];
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
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    self.definesPresentationContext = YES;
    self.searchController.dimsBackgroundDuringPresentation = NO;
   
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
 //   [self.navigationController.navigationBar horo_makeWhiteAndTransparent];
    
    
    /*
	if ([self.navigationItem respondsToSelector:@selector(setSearchController:)]) {
		// For iOS 11 and later, we place the search bar in the navigation bar.
		self.navigationController.navigationBar.prefersLargeTitles = YES;
		self.navigationItem.searchController = self.searchController;
		
		// We want the search bar visible all the time.
		self.navigationItem.hidesSearchBarWhenScrolling = NO;
	}
	else {
		// For iOS 10 and earlier, we place the search bar in the table view's header.
		self.tableView.tableHeaderView = self.searchController.searchBar;
	}

    // We want ourselves to be the delegate for this filtered table so didSelectRowAtIndexPath is called for both tables.
    self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    
    // Search is now just presenting a view controller. As such, normal view controller presentation semantics apply. Namely that presentation will walk up the view controller hierarchy until it finds the root view controller or one that defines a presentation context.
    
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
     */
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


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark - UISearchControllerDelegate

/** Called after the search controller's search bar has agreed to begin editing or when
	'active' is set to YES.
	If you choose not to present the controller yourself or do not implement this method,
	a default presentation is performed on your behalf.

	Implement this method if the default presentation is not adequate for your purposes.
*/
- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allFriends.count;
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
    [cell setName:person.name birthday:person.birthday];
    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    APLProduct *product = self.products[indexPath.row];
    [self configureCell:cell forProduct:product];
    
    return cell;
}
*/

/** Here we are the table view delegate for both our main table and filtered table, so we can
	push from the current navigation controller (resultsTableController's parent view controller
	is not this UINavigationController)
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
  
}


#pragma mark - UIStateRestoration

/** We restore several items for state restoration:
	1) Search controller's active state,
	2) search text,
	3) first responder
*/
NSString *const ViewControllerTitleKey = @"ViewControllerTitleKey";
NSString *const SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
NSString *const SearchBarTextKey = @"SearchBarTextKey";
NSString *const SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the view state so it can be restored later
    
    // encode the title
    [coder encodeObject:self.title forKey:ViewControllerTitleKey];
    
    UISearchController *searchController = self.searchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the title
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
    
	/** Restore the active state:
  		we can't make the searchController active here since it's not part of the view
		hierarchy yet, instead we do it in viewWillAppear
    */
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
	/** Restore the first responder status:
		We can't make the searchController first responder here since it's not part of the view
		hierarchy yet, instead we do it in viewWillAppear
    */
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    self.searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
}

#pragma mark -
- (void)updateAllFriends {
    NSMutableArray *array = [NSMutableArray new];
    for (strong<Person> person : _viewModel->allFriends()) {
        PersonObjc *personObject = [[PersonObjc alloc] initWithPerson:person];
        [array addObject:personObject];
    }
    _allFriends = array;
}

#pragma mark - Private Methods
- (IBAction)menuTapped:(id)sender {
    _viewModel->menuTapped();
}

@end

