//
// Created by KaiKai on 2023/5/3.
//

#import <Foundation/Foundation.h>


@interface KaiObjProxy : NSProxy

- (void)transformObjc:(NSObject *)obj;

@end