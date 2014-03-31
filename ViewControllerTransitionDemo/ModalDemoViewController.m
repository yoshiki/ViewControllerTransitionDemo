#import "ModalDemoViewController.h"
#import "CustomModalTransition.h"

@implementation ModalDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Modal Demo";
}

- (IBAction)show:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Modal"];
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    CustomModalTransition *transition = [CustomModalTransition new];
    transition.isPresenting = YES;
    return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [CustomModalTransition new];
}

- (IBAction)unwindToModalDemoViewController:(UIStoryboardSegue *)segue
{
}

@end
