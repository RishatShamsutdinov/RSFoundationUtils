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

#ifndef RSFoundationUtils_RSSwizzlingMacros_h
#define RSFoundationUtils_RSSwizzlingMacros_h

#import <objc/runtime.h>

#define RS_ORIGINAL_IMP(name) __original_ ## name ## Imp
#define RS_SWIZZLED_IMP(name) __swizzled_ ## name ## Imp

#define RS_SWIZZLED_METHOD(name, ...) RS_SWIZZLED_IMP(name)(id self, SEL _cmd, __VA_ARGS__)
#define RS_SWIZZLED_METHOD_WO_ARGS(name) RS_SWIZZLED_IMP(name)(id self, SEL _cmd)

#define RS_SWIZZLE_SEL(clazz, sel, name) \
    Method name ## Method = class_getInstanceMethod((clazz), (sel));                                  \
                                                                                                    \
    RS_ORIGINAL_IMP(name) = method_setImplementation(name ## Method, (IMP)RS_SWIZZLED_IMP(name))    \

#define RS_SWIZZLE(clazz, selectorName, name) RS_SWIZZLE_SEL((clazz), @selector((selectorName)), (name))

#define RS_INVOKE_ORIGINAL_IMP0(returnType, name) \
    ((returnType (*)(id, SEL))RS_ORIGINAL_IMP(name))(self, _cmd)

#define RS_INVOKE_ORIGINAL_IMP1(returnType, name, arg0) \
    ((returnType (*)(id, SEL, typeof(arg0)))RS_ORIGINAL_IMP(name))(self, _cmd, arg0)

#define RS_INVOKE_ORIGINAL_IMP2(returnType, name, arg0, arg1) \
    ((returnType (*)(id, SEL, typeof(arg0), typeof(arg1)))RS_ORIGINAL_IMP(name))(self, _cmd, arg0, arg1)

#define RS_INVOKE_ORIGINAL_IMP3(returnType, name, arg0, arg1, arg2) \
    ((returnType (*)(id, SEL, typeof(arg0), typeof(arg1), typeof(arg2)))RS_ORIGINAL_IMP(name))(self, _cmd, arg0, arg1, arg2)

#define RS_INVOKE_ORIGINAL_IMP4(returnType, name, arg0, arg1, arg2, arg3) \
    ((returnType (*)(id, SEL, typeof(arg0), typeof(arg1), typeof(arg2), typeof(arg3)))RS_ORIGINAL_IMP(name))(self, _cmd, arg0, arg1, arg2, arg3)

#define RS_INVOKE_ORIGINAL_IMP5(returnType, name, arg0, arg1, arg2, arg3, arg4) \
    ((returnType (*)(id, SEL, typeof(arg0), typeof(arg1), typeof(arg2), typeof(arg3), typeof(arg4)))RS_ORIGINAL_IMP(name))(self, _cmd, arg0, arg1, arg2, arg3, arg4)

#define RS_INVOKE_ORIGINAL_IMP6(returnType, name, arg0, arg1, arg2, arg3, arg4, arg5) \
    ((returnType (*)(id, SEL, typeof(arg0), typeof(arg1), typeof(arg2), typeof(arg3), typeof(arg4), typeof(arg5)))RS_ORIGINAL_IMP(name))(self, _cmd, arg0, arg1, arg2, arg3, arg4, arg5)

#define RS_INVOKE_ORIGINAL_IMP7(returnType, name, arg0, arg1, arg2, arg3, arg4, arg5, arg6) \
    ((returnType (*)(id, SEL, typeof(arg0), typeof(arg1), typeof(arg2), typeof(arg3), typeof(arg4), typeof(arg5), typeof(arg6)))RS_ORIGINAL_IMP(name))(self, _cmd, arg0, arg1, arg2, arg3, arg4, arg5, arg6)

#endif
