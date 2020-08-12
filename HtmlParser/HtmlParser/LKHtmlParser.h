//
//  LKHtmlParser.h
//  HtmlParser
//
//  Created by zhenghongyi on 2019/1/11.
//  Copyright © 2019 Coremail. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LKHtmlElement.h"

NS_ASSUME_NONNULL_BEGIN

@interface LKHtmlParser : NSObject

- (instancetype)initWithData:(nonnull NSData *)data encoding:(nullable NSString *)encoding;

- (void)beginParser;
- (void)endParser;

- (void)handleWithXPathQuery:(NSString *)query action:(nullable void(^)(NSArray<LKHtmlElement*>* _Nullable elements))action;

- (nullable NSString *)resultHtml;

@end

NS_ASSUME_NONNULL_END
