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

static const NSUInteger EmojiLowerBound = 0xd800;
static const NSUInteger EmojiUpperBound = 0xdbff;
- (BOOL)isEmoji;
{
    if (self.length != 2)
        return NO;
    const unichar c = [self characterAtIndex:0];
    return (EmojiLowerBound <= c && c <= EmojiUpperBound);
}

- (NSRange)rangeForADNRange:(NSRange)adnRange
{
    __block NSRange range = adnRange;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        if (substringRange.location >= range.location + range.length) {
            *stop = YES;
        } else if ([substring isEmoji]) {
            if (substringRange.location < range.location)
                range.location++;
            else
                range.length++;
        }
    }];
    return range;
}

- (NSRange)rangeForEntity:(NSDictionary *)entity {
    NSRange adnRange = NSMakeRange([[entity objectForKey:@"pos"] unsignedIntegerValue], [[entity objectForKey:@"len"] unsignedIntegerValue]);
    
    return [self rangeForADNRange:adnRange];
}

@end