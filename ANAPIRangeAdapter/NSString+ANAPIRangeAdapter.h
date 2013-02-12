//
//  NSString+ANAPIRangeAdapter.h
//  ANAPIRangeAdapter
//
//  Created by Bryan Berg on 2/11/13.
//  Copyright (c) 2013 Mixed Media Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ANAPIRangeAdapter)

- (NSRange)an_rangeOfCharactersForAPIRange:(NSRange)apiRange;
- (NSRange)an_rangeOfCharactersForEntity:(NSDictionary *)entity;

@end
