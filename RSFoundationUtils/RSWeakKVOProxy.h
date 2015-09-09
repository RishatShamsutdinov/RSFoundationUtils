//
//  RSWeakKVOProxy.h
//  RSFoundationUtils
//
//  Created by rishat on 09.09.15.
//
//

#import <Foundation/Foundation.h>

@interface RSWeakKVOProxy : NSProxy

- (instancetype)initWithTarget:(id)target;

@end
