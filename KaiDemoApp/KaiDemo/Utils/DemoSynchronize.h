//
//  DemoSynchronize.h
//  KaiDemo
//
//  Created by KaiKai on 2023/5/7.
//

#import <Foundation/Foundation.h>

static inline void Demo_onMainThread(void (^block)(void)) {
    if ([NSOperationQueue.currentQueue isEqual:NSOperationQueue.mainQueue] || [NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

static inline void Demo_onMainThreadSync(void (^block)(void)) {
    if ([NSOperationQueue.currentQueue isEqual:NSOperationQueue.mainQueue] || [NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

static inline void Demo_onGlobalThreadAsync(void (^block)(void)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}
