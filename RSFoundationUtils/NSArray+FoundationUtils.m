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

#import "NSArray+FoundationUtils.h"

@implementation NSArray (FoundationUtils)

- (NSArray *)rs_mapUsingBlock:(id (^)(id, NSUInteger))block {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:(self.count + 1)];

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id newValue = block(obj, idx);

        if (!newValue) {
            newValue = [NSNull null];
        }

        [result addObject:newValue];
    }];

    return result;
}

- (NSArray *)rs_filteredArrayUsingBlock:(BOOL (^)(id))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:
                                              ^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                                  return block(evaluatedObject);
                                              }]];
}

- (id)rs_objectPassingTest:(BOOL (^)(id))predicate {
    NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return predicate(obj);
    }];

    if (index == NSNotFound) {
        return nil;
    }

    return [self objectAtIndex:index];
}

- (id)rs_objectWithClass:(Class)aClass {
    return [self rs_objectPassingTest:^BOOL(id obj) {
        return [obj isKindOfClass:aClass];
    }];
}

- (void)rs_enumerateObjectsWithClass:(Class)aClass usingBlock:(void (^)(id, NSUInteger, BOOL *))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:aClass]) {
            block(obj, idx, stop);
        }
    }];
}

- (NSArray *)rs_arrayWithoutNulls {
    return [self rs_filteredArrayUsingBlock:^BOOL(id obj) {
        return obj != [NSNull null];
    }];
}

- (NSString *)rs_componentsJoinedByComma {
    return [self componentsJoinedByString:@","];
}

@end
