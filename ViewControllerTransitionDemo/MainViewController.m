#import "MainViewController.h"
#import "ModalDemoViewController.h"
#import "NavigationViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) NSArray *rowInfos;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _rowInfos = @[
                  @{
                      @"title": @"Modal",
                      @"class": @"ModalDemoViewController",
                      },
                  @{
                      @"title": @"Navigation",
                      @"class": @"NavigationDemoViewController",
                      },
                  @{
                      @"title": @"Navigation with interaction",
                      @"class": @"NavigationInteractionDemoViewController",
                      },
                  ];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rowInfos.count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *rowInfo = _rowInfos[indexPath.row];
    cell.textLabel.text = rowInfo[@"title"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = _rowInfos[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:rowInfo[@"class"]];
    if (indexPath.row == 2) {
        NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
