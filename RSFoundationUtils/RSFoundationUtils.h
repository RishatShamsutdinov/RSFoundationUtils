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

#import "NSArray+FoundationUtils.h"
#import "NSAttributedString+FoundationUtils.h"
#import "NSData+FoundationUtils.h"
#import "NSDictionary+FoundationUtils.h"
#import "NSFileManager+FoundationUtils.h"
#import "NSJSONSerialization+FoundationUtils.h"
#import "NSMutableArray+FoundationUtils.h"
#import "NSObject+FoundationUtils.h"
#import "NSString+FoundationUtils.h"
#import "NSNotificationCenter+FoundationUtils.h"
#import "RSGCDUtils.h"
#import "RSWeakKVOProxy.h"

id withStrongSelf(id __weak weakSelf, id (^block)(id strongSelf));

void voidWithStrongSelf(id __weak weakSelf, void (^block)(id strongSelf));

id withStrongObj(id __weak weakObj, id (^block)(id strongObj));

void voidWithStrongObj(id __weak weakObj, void (^block)(id strongObj));
