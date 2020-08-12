//
//  HtmlParserTests.m
//  HtmlParserTests
//
//  Created by zhenghongyi on 2019/1/11.
//  Copyright © 2019 Coremail. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LKHtmlParser.h"

@interface HtmlParserTests : XCTestCase

@end

@implementation HtmlParserTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSString* html = @"<div></div>";
    NSData* data = [html dataUsingEncoding:NSUTF8StringEncoding];
    LKHtmlParser* parser = [[LKHtmlParser alloc] initWithData:data encoding:nil];
    [parser beginParser];
    
    NSString* result = [parser resultHtml];
    
    [parser endParser];
    
    XCTAssertTrue([result isEqualToString:@"<html><body><div>\n</div></body></html>"]);
}

- (void)testAddPreSlibing {
    NSString* html = @"<div><table></table></div>";
    NSData* data = [html dataUsingEncoding:NSUTF8StringEncoding];
    LKHtmlParser* parser = [[LKHtmlParser alloc] initWithData:data encoding:nil];
    [parser beginParser];
    
    [parser handleWithXPathQuery:@"//table" action:^(NSArray<LKHtmlElement *> * _Nullable elements) {
        LKHtmlElement* newE = [LKHtmlElement create:@"hr" attribute:@{@"id":@"TablePreHr"}];
        LKHtmlElement* tableE = elements.firstObject;
        [tableE addPreSibling:newE];
    }];
    
    NSString* result = [parser resultHtml];
    
    [parser endParser];
    
    XCTAssertTrue([result isEqualToString:@"<html><body><div><hr id=\"TablePreHr\">\n</hr><table>\n</table></div></body></html>"]);
}

- (void)testAddManyPreSlibing {
    NSString* html = @"<div><table></table></div>";
    NSData* data = [html dataUsingEncoding:NSUTF8StringEncoding];
    LKHtmlParser* parser = [[LKHtmlParser alloc] initWithData:data encoding:nil];
    [parser beginParser];
    
    [parser handleWithXPathQuery:@"//table" action:^(NSArray<LKHtmlElement *> * _Nullable elements) {
        LKHtmlElement* newHR = [LKHtmlElement create:@"hr" attribute:@{@"id":@"TablePreHr"}];
        LKHtmlElement* tableE = elements.firstObject;
        [tableE addPreSibling:newHR];
        
        LKHtmlElement* newDiv = [LKHtmlElement create:@"div" attribute:@{@"class":@"tmpDiv"}];
        [tableE addPreSibling:newDiv];
    }];
    
    NSString* result = [parser resultHtml];
    
    [parser endParser];
    
    XCTAssertTrue([result isEqualToString:@"<html><body><div><hr id=\"TablePreHr\">\n</hr><div class=\"tmpDiv\">\n</div><table>\n</table></div></body></html>"]);
}

- (void)testEmpty {
    NSString* html = @"";
    NSData* data = [html dataUsingEncoding:NSUTF8StringEncoding];
    LKHtmlParser* parser = [[LKHtmlParser alloc] initWithData:data encoding:nil];
    [parser beginParser];
    
    NSString* result = [parser resultHtml];
    
    [parser endParser];
    
    XCTAssertNil(result);
}

- (void)testReusltWithCDATA {
    NSString* html = @"<html lang=\"en\">\n\r\n<head>\n\r\n\n\r\n<title>\n\r\nGitLab\n\r\n</title>\n\r\n\n\r\n\n\r\n<style>img {\n\r\nmax-width: 100%; height: auto;\n\r\n}\n\r\n</style>\n\r\n</head>\n\r\n<body>\n\r\n<div class=\"content\">\n\r\n<p>\n\r\nMerge Request !151 was closed by 许强\n\r\n</p>\n\r\n\n\r\n</div>\n\r\n<div class=\"footer\" style=\"margin-top: 10px;\">\n\r\n<p style=\"font-size: small; color: #777777;\">\n\r\n—\n\r\n<br>\n\r\n<a href=\"http://git.mailtech.cn/iOS/Lunkr/merge_requests/151\">View it on GitLab</a>.\n\r\n<br>\n\r\nYou\'re receiving this email because of your account on git.mailtech.cn.\n\r\nIf you\'d like to receive fewer emails, you can\n\r\n<a href=\"http://git.mailtech.cn/sent_notifications/245a0e7e519767337b9566bcd5d7833c/unsubscribe\">unsubscribe</a>\n\r\nfrom this thread or\n\r\nadjust your notification settings.\n\r\n\n\r\n</p>\n\r\n</div>\n\r\n</body>\n\r\n</html>\n\r\n";
    NSData* data = [html dataUsingEncoding:NSUTF8StringEncoding];
    LKHtmlParser* parser = [[LKHtmlParser alloc] initWithData:data encoding:nil];
    [parser beginParser];
    
    NSString* result = [parser resultHtml];
    
    [parser endParser];
    
    XCTAssertFalse([result containsString:@"<![CDATA"]);
}

- (void)testSpecialCharacters {
    NSString* html = @"<div>\\n</div><br>\\t<br/>哈哈<br/><br/>";
    
    NSData* data = [html dataUsingEncoding:NSUTF8StringEncoding];
    LKHtmlParser* parser = [[LKHtmlParser alloc] initWithData:data encoding:nil];
    [parser beginParser];
    
    NSString* result = [parser resultHtml];
    
    [parser endParser];
    
    XCTAssertTrue([result isEqualToString:@"<html><body><div>\\n</div><br/>\\t<br/>哈哈<br/><br/></body></html>"]);
}

- (void)testSelfClosedTags {
    NSString* html = @"<div>\\n</div><br/><br>对对对<br/>哈哈<br/><br/>";
    NSData* data = [html dataUsingEncoding:NSUTF8StringEncoding];
    LKHtmlParser* parser = [[LKHtmlParser alloc] initWithData:data encoding:nil];
    [parser beginParser];
    NSString* result = [parser resultHtml];
    [parser endParser];
    XCTAssertTrue([result isEqualToString:@"<html><body><div>\\n</div><br/><br/>对对对<br/>哈哈<br/><br/></body></html>"]);
    
    html = @"<div>哈哈哈<p></p>哈<p>但是\nowi</p>快递</div>";
    data = [html dataUsingEncoding:NSUTF8StringEncoding];
    parser = [[LKHtmlParser alloc] initWithData:data encoding:nil];
    [parser beginParser];
    result = [parser resultHtml];
    [parser endParser];
    XCTAssertTrue([result isEqualToString:@"<html><body><div>哈哈哈<p/>哈<p>但是\nowi</p>快递</div></body></html>"]);
}

@end
