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

#import "RSFoundationUtils.h"

id withStrongSelf(id __weak weakSelf, id (^block)(__typeof__(weakSelf) strongSelf)) {
    return withStrongObj(weakSelf, block);
}

void voidWithStrongSelf(id __weak weakSelf, void (^block)(__typeof__(weakSelf) strongSelf)) {
    voidWithStrongObj(weakSelf, block);
}

id withStrongObj(id __weak weakObj, id (^block)(id strongObj)) {
    typeof(weakObj) __strong strongObj = weakObj;

    if (strongObj) {
        return block(strongObj);
    }

    return nil;
}

void voidWithStrongObj(id __weak weakObj, void (^block)(id strongObj)) {
    typeof(weakObj) __strong strongObj = weakObj;

    if (strongObj) {
        block(strongObj);
    }
}