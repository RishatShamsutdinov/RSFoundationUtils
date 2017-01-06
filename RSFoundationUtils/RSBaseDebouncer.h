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

#import <Foundation/Foundation.h>

typedef void (^RSDebouncerBlock)();

@protocol RSDebouncerTimer <NSObject>

- (void)invalidate;

@end

@interface RSBaseDebouncer : NSObject

+ (id<RSDebouncerTimer>)scheduleBlock:(void (^)())block withDelay:(NSTimeInterval)delay
                              onQueue:(dispatch_queue_t)queue;

+ (instancetype)debouncerWithDelay:(NSTimeInterval)delay;
+ (instancetype)debouncerWithDelay:(NSTimeInterval)delay queue:(dispatch_queue_t)queue;

- (instancetype)initWithDelay:(NSTimeInterval)delay;
- (instancetype)initWithDelay:(NSTimeInterval)delay queue:(dispatch_queue_t)queue;

- (void)debounceWithBlock:(RSDebouncerBlock)block;

- (void)cancel;

@end
