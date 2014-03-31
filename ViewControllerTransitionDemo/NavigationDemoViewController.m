#import "NavigationDemoViewController.h"
#import "CustomNavigationTransition.h"

@implementation NavigationDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Navigation Demo";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
}

- (IBAction)show:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Navigation"];
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [CustomNavigationTransition new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    CustomNavigationTransition *transition = [CustomNavigationTransition new];
    transition.isPushing = YES;
    return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    CustomNavigationTransition *transition = [CustomNavigationTransition new];
    transition.isPushing = (operation == UINavigationControllerOperationPush);
    return transition;
}

@end
