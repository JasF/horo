#include "viewmodels/friendsscreenviewmodel/friendsscreenviewmodel.h"
#import "FriendsBaseViewController.h"
#import "Controllers.h"

@interface FriendsViewController : FriendsBaseViewController
@property (assign, nonatomic) strong<horo::FriendsScreenViewModel> viewModel;
@property (strong, nonatomic) id<WebViewController> webViewController;
@end
