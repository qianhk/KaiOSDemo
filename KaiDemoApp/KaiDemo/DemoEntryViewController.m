//
//  DemoEntryViewController.m
//  KaiDemo
//
//  Created by KaiKai on 2023/5/3.
//

#import "DemoEntryViewController.h"
#import "ZaTestListViewController.h"

@interface DemoEntryViewController () {
    
    NSArray *_entryArray;
    
}

@end

@implementation DemoEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"凯Demo";
    UITableView *const tableView = self.tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor orangeColor];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.tableFooterView = [UIView new];
    tableView.estimatedRowHeight = 60;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"DemoTextTableViewCell"];
    
    _entryArray = @[
            @{@"Name": @"杂七杂八测试", @"Vc": @"ZaTestListViewController"},
            @{@"Name": @"Demo Test List2", @"Vc": @"XxxxVC2"},
            @{@"Name": @"Demo Test List3", @"Vc": @"XxxxVC3"},
            @{@"Name": @"Demo Test List4", @"Vc": @"XxxxVC4"},
            @{@"Name": @"Demo Test List5", @"Vc": @"XxxxVC5"},
    ];
    [self performSelector:@selector(autoEnterPage) withObject:nil afterDelay:0.5];
    
}

- (void)autoEnterPage {
    const NSInteger rowIndex = 1;
//    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _entryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DemoTextTableViewCell"];
    NSDictionary *rowDic = _entryArray[indexPath.row];
    cell.textLabel.text = rowDic[@"Name"];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewAutomaticDimension;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"didSelectRowAtIndexPath row=%ld %.2f", (long) indexPath.row, UITableViewAutomaticDimension);
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
//
    NSDictionary *item = _entryArray[indexPath.row];
    NSNumber *type = item[@"type"];
    if (type == nil) {
        Class clazz = NSClassFromString(item[@"Vc"]);
        UIViewController *vc = [clazz alloc];
        if (clazz) {
            NSString *nib = item[@"Nib"];
            if (nib) {
                vc = [vc initWithNibName:nib bundle:nil];
            } else {
                vc = [vc init];
            }
            vc.title = item[@"Name"];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            NSString *msgStr = [NSString stringWithFormat:@"名字是：%@", item[@"Vc"]];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示缺失vc" message:msgStr
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } else {
        int intType = [type intValue];
//                    if (intType == 1) {
//                        FlutterEngine *flutterEngine = ((AppDelegate *)UIApplication.sharedApplication.delegate).flutterEngine;
//                        DemoFlutterViewController *flutterViewController = [[DemoFlutterViewController alloc] initWithEngine:flutterEngine nibName:nil
////                        [self presentViewController;flutterViewController animated:YES completion:nil];
//                        [self.navigationController pushViewController:flutterViewController animated:YES];
//                    }
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}

@end
