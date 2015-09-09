//
//  RSWeakKVOProxy.m
//  RSFoundationUtils
//
//  Created by rishat on 09.09.15.
//
//

#import "RSWeakKVOProxy.h"

@interface RSWeakKVOProxy () {
    id __weak _target;
}

@end

@implementation RSWeakKVOProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;

    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return (aSelector == @selector(observeValueForKeyPath:ofObject:change:context:));
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    if (sel == @selector(observeValueForKeyPath:ofObject:change:context:)) {
        return [self methodSignatureForSelector:sel];
    }

    return [_target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:_target];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    [_target observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
