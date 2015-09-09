//
//  NSNotificationCenter+FoundationUtils.h
//  RSFoundationUtils
//
//  Created by rishat on 09.09.15.
//
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (FoundationUtils)

- (void)rs_addObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object;

@end
