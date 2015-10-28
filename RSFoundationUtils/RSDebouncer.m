/**
 *
 * Copyright 2015 Rishat Shamsutdinov
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "RSDebouncer.h"

#import <GCDTimer/GCDTimer.h>

#import "RSFoundationUtils.h"

static NSTimeInterval const kDefaultDelay = 0.25;

@interface RSDebouncer () {
    NSTimeInterval _delay;

    GCDTimer *_timer;

    dispatch_queue_t _queue;
}

@end

@implementation RSDebouncer

+ (instancetype)debouncerWithDelay:(NSTimeInterval)delay {
    return [self debouncerWithDelay:delay queue:NULL];
}

+ (instancetype)debouncerWithDelay:(NSTimeInterval)delay queue:(dispatch_queue_t)queue {
    return [[self alloc] initWithDelay:delay queue:queue];
}

- (instancetype)init {
    return [self initWithDelay:kDefaultDelay];
}

- (instancetype)initWithDelay:(NSTimeInterval)delay {
    return [self initWithDelay:delay queue:NULL];
}

- (instancetype)initWithDelay:(NSTimeInterval)aDelay queue:(dispatch_queue_t)queue {
    if (self = [super init]) {
        _delay = aDelay;
        _queue = queue;
    }

    return self;
}

- (void)debounceWithBlock:(RSDebouncerBlock)block {
    [_timer invalidate];

    dispatch_queue_t queue = _queue;

    if (queue) {
        // do nothing
    }
    else if ([NSThread isMainThread]) {
        queue = dispatch_get_main_queue();
    }
    else {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }

    block = [block copy];

    typeof(self) __weak weakSelf = self;

    _timer = [GCDTimer scheduledTimerWithTimeInterval:_delay repeats:NO queue:queue block:^{
        voidWithStrongSelf(weakSelf, ^(typeof(self) self) {
            block();
        });
    }];
}

- (void)dealloc {
    [_timer invalidate];
}

@end
