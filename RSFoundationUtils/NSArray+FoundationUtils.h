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

@interface NSArray (FoundationUtils)

- (NSArray *)rs_mapUsingBlock:(id (^)(id obj, NSUInteger idx))block;

- (NSArray *)rs_filteredArrayUsingBlock:(BOOL (^)(id obj))block;

- (id)rs_objectPassingTest:(BOOL (^)(id obj))predicate;

- (id)rs_objectWithClass:(Class)aClass;

- (void)rs_enumerateObjectsWithClass:(Class)aClass usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (NSArray *)rs_arrayWithoutNulls;

- (NSString *)rs_componentsJoinedByComma;

@end
