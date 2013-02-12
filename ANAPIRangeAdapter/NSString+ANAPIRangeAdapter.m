//
//  NSString+ANAPIRangeAdapter.m
//  ANAPIRangeAdapter
//
//  Created by Bryan Berg on 2/11/13.
//  Copyright (c) 2013 Mixed Media Labs, Inc. All rights reserved.
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
