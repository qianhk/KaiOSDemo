//
// Created by KaiKai on 2023/5/3.
//

#import <UIKit/UIKit.h>


@interface BaseTestListViewController : UITableViewController

- (void)addOneTest:(NSString *)name selector:(SEL)selector;

- (void)addOneTest:(NSString *)name selector:(SEL)selector withObject:(nullable id)anArgument;

@end