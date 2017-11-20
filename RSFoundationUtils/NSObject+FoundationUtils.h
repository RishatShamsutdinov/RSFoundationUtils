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
#import <objc/runtime.h>

@interface NSObject (FoundationUtils)

- (void)rs_setAssociatedObject:(id)object forKey:(const void *)key withPolicy:(objc_AssociationPolicy)policy
          dependenciesKeyPaths:(NSString *)keyPath, ... NS_REQUIRES_NIL_TERMINATION;

- (void)rs_setAssociatedObject:(id)object forKey:(const void *)key withPolicy:(objc_AssociationPolicy)policy
 dependenciesKeyPathsFromArray:(NSArray<NSString *> *)keyPaths;

- (id)rs_associatedObjectForKey:(const void *)key;

- (id)rs_copyWithProperties:(SEL)property, ... NS_REQUIRES_NIL_TERMINATION;

- (void)rs_changeValuesUsingBlock:(void (^)(void))block forKeyPaths:(NSString *)keyPath, ... NS_REQUIRES_NIL_TERMINATION;

@end
