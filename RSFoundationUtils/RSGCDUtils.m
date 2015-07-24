//
//  RSGCDUtils.m
//  RSFoundationUtils
//
//  Created by rishat on 24.07.15.
//
//

#import <Foundation/Foundation.h>

static void * kQSpecificContextKey = &kQSpecificContextKey;

static void __freeQSpecificContext(void *c) {
    free(c);
}

dispatch_queue_t rs_dispatch_specific_queue_create(const char *label, dispatch_queue_attr_t attr) {
    dispatch_queue_t q = dispatch_queue_create(label, attr);

    void * context = malloc(1);

    dispatch_queue_set_specific(q, kQSpecificContextKey, context, __freeQSpecificContext);

    return q;
}

void rs_dispatch_specific_sync(dispatch_queue_t queue, dispatch_block_t block) {
    if (dispatch_get_specific(kQSpecificContextKey) == dispatch_queue_get_specific(queue, kQSpecificContextKey)) {
        block();
    } else {
        dispatch_sync(queue, block);
    }
}

void rs_dispatch_assert_specific_queue(dispatch_queue_t queue) {
    if (dispatch_get_specific(kQSpecificContextKey) != dispatch_queue_get_specific(queue, kQSpecificContextKey)) {
        const char * label = dispatch_queue_get_label(queue);

        NSString *queueName = label ? [NSString stringWithCString:label encoding:NSASCIIStringEncoding] : @"";
        NSString *reason = [NSString stringWithFormat:@"Code must be executed in specific queue (\"%@\")", queueName];

        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:reason userInfo:nil];
    }
}