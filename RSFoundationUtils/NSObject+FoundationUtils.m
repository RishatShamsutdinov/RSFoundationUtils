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

#import "NSObject+FoundationUtils.h"
#import "RSWeakObjectContainer.h"

#pragma mark - _RSAssociatedObjectContainer -

@interface _RSAssociatedObjectContainer : NSObject

@property (nonatomic, readonly) NSDictionary *dependencies;

- (instancetype)initWithDependencies:(NSDictionary *)dependecies;

@end

@implementation _RSAssociatedObjectContainer

- (instancetype)initWithDependencies:(NSDictionary *)dependecies {
    if (self = [self init]) {
        _dependencies = [dependecies copy];
    }

    return self;
}

@end

#pragma mark - NSObject (FoundationUtils) -

@implementation NSObject (FoundationUtils)

- (void)rs_setAssociatedObject:(id)object forKey:(const void *)key withPolicy:(objc_AssociationPolicy)policy
          dependenciesKeyPaths:(NSString *)keyPath, ...
{
    NSMutableArray<NSString *> *keyPaths = [NSMutableArray new];

    va_list keyPathsArgs;
    va_start(keyPathsArgs, keyPath);

    for (NSString *arg = keyPath; arg != nil; arg = va_arg(keyPathsArgs, NSString *)) {
        [keyPaths addObject:arg];
    }

    va_end(keyPathsArgs);

    [self rs_setAssociatedObject:object forKey:key withPolicy:policy dependenciesKeyPathsFromArray:keyPaths];
}

- (void)rs_setAssociatedObject:(id)object forKey:(const void *)key withPolicy:(objc_AssociationPolicy)policy
 dependenciesKeyPathsFromArray:(NSArray<NSString *> *)keyPaths
{
    NSMutableDictionary *dependencies = [NSMutableDictionary dictionaryWithCapacity:(keyPaths.count + 1)];

    [keyPaths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id dependency = [self valueForKeyPath:obj];

        if (!dependency) {
            dependency = [NSNull null];
        }

        dependencies[obj] = [RSWeakObjectContainer containerWithObject:dependency];
    }];

    _RSAssociatedObjectContainer *container = [[_RSAssociatedObjectContainer alloc] initWithDependencies:dependencies];

    objc_setAssociatedObject(container, key, object, policy);
    objc_setAssociatedObject(self, key, container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)rs_associatedObjectForKey:(const void *)key {
    _RSAssociatedObjectContainer *container = objc_getAssociatedObject(self, key);

    BOOL __block dependenciesDidChange = NO;

    [container.dependencies enumerateKeysAndObjectsUsingBlock:
     ^(NSString *key, RSWeakObjectContainer *obj, BOOL *stop) {
         id value = obj.object;

         if (value == [NSNull null]) {
             value = nil;
         }

         if (value != [self valueForKeyPath:key]) {
             dependenciesDidChange = YES;

             *stop = YES;
         }
     }];

    if (dependenciesDidChange) {
        objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        return nil;
    }
    
    return objc_getAssociatedObject(container, key);
}

- (id)rs_copyWithProperties:(SEL)property, ... NS_REQUIRES_NIL_TERMINATION {
    id result = [[self class] alloc];

    va_list args;
    va_start(args, property);

    for (SEL arg = property; arg != nil; arg = va_arg(args, SEL)) {
        NSString *key = NSStringFromSelector(arg);

        [result setValue:[self valueForKey:key] forKey:key];
    }

    va_end(args);

    return result;
}

- (void)rs_changeValuesUsingBlock:(void (^)())block forKeyPaths:(NSString *)keyPath, ... NS_REQUIRES_NIL_TERMINATION {
    va_list keyPathAp;
    va_start(keyPathAp, keyPath);

    NSMutableArray *keyPaths = [NSMutableArray new];

    for (NSString * kp = keyPath; kp != nil; kp = va_arg(keyPathAp, NSString *)) {
        [keyPaths addObject:kp];
    }

    va_end(keyPathAp);

    [keyPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self willChangeValueForKey:obj];
    }];

    block();

    [keyPaths enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self didChangeValueForKey:obj];
    }];
}

@end
