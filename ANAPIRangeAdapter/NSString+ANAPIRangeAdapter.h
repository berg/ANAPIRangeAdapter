//
//  NSString+ANAPIRangeAdapter.h
//  ANAPIRangeAdapter
//
//  Created by Bryan Berg on 2/11/13.
//
//  The author or authors of this code dedicate any and all copyright
//  interest in this code to the public domain. We make this dedication for
//  the benefit of the public at large and to the detriment of our heirs and
//  successors. We intend this dedication to be an overt act of
//  relinquishment in perpetuity of all present and future rights to this
//  code under copyright law.
//

#import <Foundation/Foundation.h>

@interface NSString (ANAPIRangeAdapter)

- (NSRange)an_rangeOfCharactersForAPIRange:(NSRange)apiRange;
- (NSRange)an_rangeOfCharactersForEntity:(NSDictionary *)entity;

@end
