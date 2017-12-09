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
#import "UINavigationBar+Horo.h"
#import <WebKit/WebKit.h>
#import "UIImage+Horo.h"
#include "data/person.h"
#import "UIView+Horo.h"
#import "PersonObjc.h"
#import "FriendsCell.h"
#import "WebViewControllerUIDelegate.h"
#import "FriendsResultsViewController.h"

@interface APLMainTableViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UIScrollViewDelegate, WebViewControllerUIDelegate>

@property (nonatomic, strong) UISearchController *searchController;

// Our secondary search results table view.
@property (nonatomic, strong) FriendsResultsViewController *resultsTableController;
@property (nonatomic, strong) NSArray<PersonObjc *> *allFriends;
@property (strong, nonatomic) IBOutlet UITableViewCell *updateFriendsCell;

// For state restoration.
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

using namespace std;
using namespace horo;

@implementation APLMainTableViewController
- (void)viewDidLoad {
    NSCParameterAssert(_viewModel);
    NSCParameterAssert(_webViewController);
    [super viewDidLoad];
    [self updateAllFriends];

    _resultsTableController = [FriendsResultsViewController new];//[[APLResultsTableController alloc] init];
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
   
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    for (UIView *subview in self.tableView.subviews) {
        subview.backgroundColor = [UIColor clearColor];
    }
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
    return _allFriends.count + 1;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}

#pragma mark - Private
- (void)updateAllFriends {
    NSMutableArray *array = [NSMutableArray new];
    for (strong<Person> person : _viewModel->allFriends()) {
        PersonObjc *personObject = [[PersonObjc alloc] initWithPerson:person];
        [array addObject:personObject];
    }
    _allFriends = array;
}

#pragma mark - Observers
- (IBAction)menuTapped:(id)sender {
    _viewModel->menuTapped();
}
- (IBAction)updateFriendsTapped:(id)sender {
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

@end
