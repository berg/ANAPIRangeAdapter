//
//  ANAPIRangeAdapterTests.m
//  ANAPIRangeAdapterTests
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

#import "ANAPIRangeAdapterTests.h"
#import "NSString+ANAPIRangeAdapter.h"

@implementation ANAPIRangeAdapterTests

- (void)setUp {
    [super setUp];

    _post_443970 = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"post_443970" ofType:@"json"]];
    _post_2919215 = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"post_2919215" ofType:@"json"]];
    _post_2919218 = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"post_2919218" ofType:@"json"]];
    _post_2919223 = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"post_2919223" ofType:@"json"]];
    _post_2919865 = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"post_2919865" ofType:@"json"]];

    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.

    [super tearDown];
}

- (void)testComposedCharacterOnly {
    NSError *error;
    NSDictionary *post = [NSJSONSerialization JSONObjectWithData:_post_2919218 options:0 error:&error];

    STAssertNil(error, @"Error decoding JSON");
    STAssertNotNil(post, @"post was nil");

    NSDictionary *data = [post objectForKey:@"data"];

    NSString *text = [data objectForKey:@"text"];
    NSDictionary *mention = [[[data objectForKey:@"entities"] objectForKey:@"mentions"] objectAtIndex:0];
    NSRange range = [text rangeForEntity:mention];

    STAssertEqualObjects(@"@fooby", [text substringWithRange:range], @"mention text did not match");
}

- (void)testBoth {
    NSError *error;
    NSDictionary *post = [NSJSONSerialization JSONObjectWithData:_post_2919215 options:0 error:&error];

    STAssertNil(error, @"Error decoding JSON");
    STAssertNotNil(post, @"post was nil");

    NSDictionary *data = [post objectForKey:@"data"];

    NSString *text = [data objectForKey:@"text"];
    NSDictionary *mention = [[[data objectForKey:@"entities"] objectForKey:@"mentions"] objectAtIndex:0];
    NSRange range = [text rangeForEntity:mention];

    STAssertEqualObjects(@"@fooby", [text substringWithRange:range], @"mention text did not match");
}

- (void)testEmojiOnly {
    NSError *error;
    NSDictionary *post = [NSJSONSerialization JSONObjectWithData:_post_2919223 options:0 error:&error];

    STAssertNil(error, @"Error decoding JSON");
    STAssertNotNil(post, @"post was nil");

    NSDictionary *data = [post objectForKey:@"data"];

    NSString *text = [data objectForKey:@"text"];
    NSDictionary *mention = [[[data objectForKey:@"entities"] objectForKey:@"mentions"] objectAtIndex:0];
    NSRange range = [text rangeForEntity:mention];

    STAssertEqualObjects(@"@fooby", [text substringWithRange:range], @"mention text did not match");
}

- (void)testContainingTag {
    NSError *error;
    NSDictionary *post = [NSJSONSerialization JSONObjectWithData:_post_2919865 options:0 error:&error];

    STAssertNil(error, @"Error decoding JSON");
    STAssertNotNil(post, @"post was nil");

    NSDictionary *data = [post objectForKey:@"data"];
    NSString *text = [data objectForKey:@"text"];

    NSDictionary *mention = [[[data objectForKey:@"entities"] objectForKey:@"mentions"] objectAtIndex:0];
    NSRange mentionRange = [text rangeForEntity:mention];
    STAssertTrue([[text substringWithRange:mentionRange] isEqualToString:@"@fooby"], @"mention text did not match");

    NSDictionary *link = [[[data objectForKey:@"entities"] objectForKey:@"links"] objectAtIndex:0];
    NSRange linkRange = [text rangeForEntity:link];
    STAssertEqualObjects(@"http://🍺🍺hashtag.tk", [text substringWithRange:linkRange], @"link text did not match");
}

- (void)testCrazyTonyMillionPost {
    NSError *error;
    NSDictionary *post = [NSJSONSerialization JSONObjectWithData:_post_443970 options:0 error:&error];

    STAssertNil(error, @"Error decoding JSON");
    STAssertNotNil(post, @"post was nil");

    NSDictionary *data = [post objectForKey:@"data"];
    NSString *text = [data objectForKey:@"text"];

    NSDictionary *hashtag = [[[data objectForKey:@"entities"] objectForKey:@"hashtags"] objectAtIndex:0];
    NSRange hashtagRange = [text rangeForEntity:hashtag];
    STAssertEqualObjects(@"#lol", [text substringWithRange:hashtagRange], @"hashtag text did not match");
}

@end
