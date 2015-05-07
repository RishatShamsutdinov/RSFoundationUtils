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

static NSTimeInterval const kDefaultDelay = 0.25;

@interface RSDebouncer () {
    NSTimer *_timer;
    NSTimeInterval _delay;
}

@end

@implementation RSDebouncer

+ (instancetype)debouncerWithDelay:(NSTimeInterval)delay {
    return [[self alloc] initWithDelay:delay];
}

- (instancetype)initWithDelay:(NSTimeInterval)aDelay {
    if (self = [self init]) {
        _delay = aDelay;
    }

    return self;
}

- (void)debounceWithBlock:(RSDebouncerBlock)block {
    [_timer invalidate];

    _timer = [NSTimer scheduledTimerWithTimeInterval:_delay ? _delay : kDefaultDelay target:self
                                            selector:@selector(performAgrregatorCompletion:)
                                            userInfo:[block copy] repeats:NO];
}

- (void)performAgrregatorCompletion:(NSTimer *)aTimer {
    RSDebouncerBlock block = aTimer.userInfo;

    block();
}

- (void)dealloc {
    [_timer invalidate];
}

@end
