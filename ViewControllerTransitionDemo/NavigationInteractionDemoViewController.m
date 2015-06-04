#import "NavigationInteractionDemoViewController.h"
#import "PopAnimatedTransition.h"

@interface NavigationInteractionDemoViewController ()

@property (nonatomic, strong) UIViewController *currentViewController;

@end

@implementation NavigationInteractionDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Navigation with interactive Demo";
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close)];
    self.navigationItem.rightBarButtonItem = closeButton;
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)show:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
