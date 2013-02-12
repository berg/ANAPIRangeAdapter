//
//  NSString+ANAPIRangeAdapter.m
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

#import "NSString+ANAPIRangeAdapter.h"

@implementation NSString (ANAPIRangeAdapter)

- (NSRange)an_rangeOfCharactersForAPIRange:(NSRange)apiRange {
    __block NSRange range = apiRange;

    [self enumerateSubstringsInRange:NSMakeRange(0, apiRange.location + apiRange.length + 1)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              if (substring.length == 2) {
                                  unichar c = [substring characterAtIndex:0];

                                  if (c >= 0xd800 && c <= 0xdfff) {
                                      // surrogate pair, so adjust

                                      if (substringRange.location > range.location) {
                                          range.length += 1;
                                      } else {
                                          range.location += 1;
                                      }
                                  }
                              }
                          }];

    return range;
}

- (NSRange)an_rangeOfCharactersForEntity:(NSDictionary *)entity {
    NSRange apiRange = NSMakeRange([[entity objectForKey:@"pos"] unsignedIntegerValue], [[entity objectForKey:@"len"] unsignedIntegerValue]);
    
    return [self an_rangeOfCharactersForAPIRange:apiRange];
}

@end
