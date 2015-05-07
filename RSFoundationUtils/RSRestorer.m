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

#import "RSRestorer.h"

@interface RSRestorer () {
    NSMutableArray *_restorationBlocks;
}

@end

@implementation RSRestorer

- (instancetype)init {
    if (self = [super init]) {
        _restorationBlocks = [NSMutableArray new];
    }

    return self;
}

- (void)pushRestorationBlock:(RSRestorationBlock)restorationBlock {
    [_restorationBlocks addObject:restorationBlock];
}

- (void)restore {
    RSRestorationBlock restorationBlock = [_restorationBlocks lastObject];

    restorationBlock();

    [_restorationBlocks removeLastObject];
}

@end
