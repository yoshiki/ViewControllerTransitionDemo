#import "NavigationViewController.h"
#import "PopAnimatedTransition.h"

@interface NavigationViewController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) PopAnimatedTransition *animatedTransition;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenInteractiveTransition;
@property (nonatomic, strong) NSMutableArray *panGestureRecognizers;

@end

@implementation NavigationViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.delegate = self;
        self.animatedTransition = [[PopAnimatedTransition alloc] init];
        self.panGestureRecognizers = @[].mutableCopy;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        viewController = navigationController.topViewController;
    }
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    recognizer.delegate = self;
    [viewController.view addGestureRecognizer:recognizer];
    [self.panGestureRecognizers addObject:recognizer];
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.panGestureRecognizers removeLastObject];
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    [self.panGestureRecognizers removeAllObjects];
    return [super popToRootViewControllerAnimated:animated];
}

#pragma mark - UIPanGestureRecognizer

- (void)handlePanGesture:(UIPanGestureRecognizer *)gr
{
    CGPoint location = [gr translationInView:gr.view];
    float progress = fabs(location.x / (gr.view.bounds.size.width * 1.0));
    progress = MIN(1.0, MAX(0.0, progress));
    
    switch (gr.state) {
        case UIGestureRecognizerStateBegan: {
            self.percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            self.percentDrivenInteractiveTransition.completionCurve = UIViewAnimationCurveLinear;
            [super popViewControllerAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.percentDrivenInteractiveTransition updateInteractiveTransition:progress];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (self.percentDrivenInteractiveTransition != nil) {
                if (progress > 0.3) {
                    [self.panGestureRecognizers removeLastObject];
                    [self.percentDrivenInteractiveTransition finishInteractiveTransition];
                } else {
                    [self.percentDrivenInteractiveTransition cancelInteractiveTransition];
                }
            }
            self.percentDrivenInteractiveTransition = nil;
            break;
        }
        default:
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint velocity = [panGestureRecognizer velocityInView:panGestureRecognizer.view];
    return fabs(velocity.y) <= fabs(velocity.x);
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return self.animatedTransition;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    UIPanGestureRecognizer *panGestureRecognizer = [self.panGestureRecognizers lastObject];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        return self.percentDrivenInteractiveTransition;
    }
    return nil;
}

@end
