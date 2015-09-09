//
//  NSNotificationCenter+FoundationUtils.m
//  RSFoundationUtils
//
//  Created by rishat on 09.09.15.
//
//

#import "NSNotificationCenter+FoundationUtils.h"

#import <objc/runtime.h>
#import <libkern/OSAtomic.h>

#import "RSSwizzlingMacros.h"

@interface RSNotifObserver : NSObject {
@private
    id __weak _target;
    SEL _targetSelector;
    NSString *_notifName;
    id __unsafe_unretained _notifSender;

    NSNotificationCenter * __weak _notifCenter;
}

- (instancetype)initWithTarget:(id)target selector:(SEL)sel name:(NSString *)name object:(id)object
                   notifCenter:(NSNotificationCenter *)notifCenter;

- (void)observeNotification:(NSNotification *)notif;

@end

static const void * kNotifObserversKey = &kNotifObserversKey;

@implementation NSNotificationCenter (FoundationUtils)

static IMP RS_ORIGINAL_IMP(removeObserver);
static IMP RS_ORIGINAL_IMP(removeObserverForName);

static void RS_SWIZZLED_METHOD(removeObserver, id observer) {
    RS_INVOKE_ORIGINAL_IMP1(void, removeObserver, observer);

    @synchronized(self) {
        NSArray *observers = objc_getAssociatedObject(observer, kNotifObserversKey);

        [observers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RS_INVOKE_ORIGINAL_IMP1(void, removeObserver, obj);
        }];
    }
}

static void RS_SWIZZLED_METHOD(removeObserverForName, id observer, NSString *name, id object) {
    RS_INVOKE_ORIGINAL_IMP3(void, removeObserverForName, observer, name, object);

    @synchronized(self) {
        NSArray *observers = objc_getAssociatedObject(observer, kNotifObserversKey);

        [observers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RS_INVOKE_ORIGINAL_IMP3(void, removeObserverForName, obj, name, object);
        }];
    }
}

+ (void)load {
    RS_SWIZZLE([self class], removeObserver:, removeObserver);
    RS_SWIZZLE([self class], removeObserver:name:object:, removeObserverForName);
}

- (void)rs_addObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object {
    NSMethodSignature *sig = [observer methodSignatureForSelector:selector];

    if (sig.numberOfArguments > 3) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Too many arguments for method"
                                     userInfo:nil];
    }

    if (strcmp(sig.methodReturnType, @encode(void)) != 0) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Method return type must be `void`"
                                     userInfo:nil];
    }

    RSNotifObserver *notifObserver = [[RSNotifObserver alloc] initWithTarget:observer
                                                                    selector:selector
                                                                        name:name
                                                                      object:object
                                                                 notifCenter:self];

    @synchronized(self) {
        NSMutableArray *observers = objc_getAssociatedObject(observer, kNotifObserversKey);

        if (!observers) {
            observers = [NSMutableArray new];

            objc_setAssociatedObject(observer, kNotifObserversKey, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }

        [observers addObject:notifObserver];

        [self addObserver:notifObserver selector:@selector(observeNotification:) name:name object:object];
    }
}

@end

@implementation RSNotifObserver

- (instancetype)initWithTarget:(id)target selector:(SEL)sel name:(NSString *)name
                        object:(id)object notifCenter:(NSNotificationCenter *)notifCenter
{
    if (self = [super init]) {
        _target = target;
        _targetSelector = sel;
        _notifName = [name copy];
        _notifSender = object;
        _notifCenter = notifCenter;
    }

    return self;
}

- (void)observeNotification:(NSNotification *)notif {
    id target = _target;

    if (!target) {
        return;
    }

    IMP anImp = [target methodForSelector:_targetSelector];
    NSMethodSignature *sig = [target methodSignatureForSelector:_targetSelector];

    if (sig.numberOfArguments > 2) {
        ((void (*)(id, SEL, NSNotification *)) anImp)(target, _targetSelector, notif);
    } else {
        ((void (*)(id, SEL)) anImp)(target, _targetSelector);
    }
}

- (void)dealloc {
    [_notifCenter removeObserver:self];
}

@end
