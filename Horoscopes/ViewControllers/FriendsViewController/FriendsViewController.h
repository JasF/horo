#include "viewmodels/friendsscreenviewmodel/friendsscreenviewmodel.h"
#import "Controllers.h"

@interface FriendsViewController : UITableViewController
@property (assign, nonatomic) strong<horo::FriendsScreenViewModel> viewModel;
@property (strong, nonatomic) id<WebViewController> webViewController;
@end
