//
// Created by KaiKai on 2023/5/7.
//

#import "NSObject+DemoDelayRunLoop.h"


@implementation NSObject (DemoDelayRunLoop)

- (void)demo_doBlockAtNextRunloop:(void (^)(void))block {
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAfterWaiting, NO, 0,
            ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
                if (activity == kCFRunLoopAfterWaiting) {
                    CFRunLoopPerformBlock(CFRunLoopGetCurrent(), kCFRunLoopCommonModes, block);
                    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
                }
            });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    CFRelease(observer);
}

@end