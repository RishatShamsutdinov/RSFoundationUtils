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

#import "NSFileManager+FoundationUtils.h"

@implementation NSFileManager (FoundationUtils)

- (NSString *)rs_createDirectoryAtTempPathIfNotExists:(NSString *)dirName
                          withIntermediateDirectories:(BOOL)createIntermediates
                                           attributes:(NSDictionary *)attributes error:(NSError *__autoreleasing *)error {

    return [self rs_createDirectoryAtPathIfNotExists:[NSTemporaryDirectory() stringByAppendingPathComponent:dirName]
                         withIntermediateDirectories:createIntermediates attributes:attributes error:error];
}

- (NSString *)rs_createDirectoryAtPathIfNotExists:(NSString *)path
                      withIntermediateDirectories:(BOOL)createIntermediates
                                       attributes:(NSDictionary *)attributes error:(NSError **)error {

    BOOL isDirectory;

    if ([self fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
        return path;
    }

    if ([self createDirectoryAtPath:path withIntermediateDirectories:createIntermediates
                         attributes:attributes error:error])
    {
        return path;
    }
    
    return nil;
}

@end
