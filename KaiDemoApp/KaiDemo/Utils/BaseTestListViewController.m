//
// Created by KaiKai on 2023/5/3.
//

#import "BaseTestListViewController.h"

@interface BaseTestListViewController () {
    NSMutableArray *_entryArray;
}

@end

@implementation BaseTestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.clearsSelectionOnViewWillAppear = NO;
    
//    self.title = @"凯XXXDemo";
    UITableView *tableView = self.tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.separatorColor = [UIColor orangeColor];
    tableView.tableFooterView = [UIView new];
    tableView.estimatedRowHeight = 60;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"DemoTextTableViewCell"];
    
    _entryArray = [NSMutableArray array];
//[self addOneTest:@"Test Item" selector:@selector(testTestSelector)];
}

- (void)addOneTest:(NSString *)name selector:(SEL)selector {
    [_entryArray addObject:@{@"name": name, @"selector": NSStringFromSelector(selector)}];
}

- (void)addOneTest:(NSString *)name selector:(SEL)selector withObject:(nullable id)anArgument {
    if (anArgument != nil) {
        [_entryArray addObject:@{
                @"name": name, @"selector": NSStringFromSelector(selector), @"argument": anArgument
        }];
    } else {
        [self addOneTest:name selector:selector];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _entryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DemoTextTableViewCell"];
    NSDictionary *rowData = _entryArray[indexPath.row];
    cell.textLabel.text = rowData[@"name"];
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *item = _entryArray[indexPath.row];
    [self performSelector:NSSelectorFromString(item[@"selector"]) withObject:item[@"argument"] afterDelay:8];
//    NSLog(@"lookKai didSelectRowAtIndexPath row=%ld %.2f", (long) indexPath.row, UITableViewAutomaticDimension);
}

@end
