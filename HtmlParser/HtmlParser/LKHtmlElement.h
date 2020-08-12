//
//  LKHtmlElement.h
//  HtmlParser
//
//  Created by zhenghongyi on 2019/1/11.
//  Copyright © 2019 Coremail. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <libxml/tree.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKHtmlElement : NSObject

@property (nonatomic, copy, readonly, nullable) NSString* html;

@property (nonatomic, copy, readonly, nullable) NSString* innerHtml;

@property (nonatomic, copy, readonly) NSString* nodeName;

@property (nonatomic, copy, readonly, nullable) NSDictionary* attribute;

@property (nonatomic, copy, readonly, nullable) NSDictionary* style;

@property (nonatomic, copy, readonly) NSArray<LKHtmlElement*>* children;

- (instancetype)initWithNode:(xmlNodePtr)node encoding:(nullable NSString *)encoding;

+ (nullable instancetype)create:(NSString *)nodeName attribute:(nullable NSDictionary<NSString*, NSString*>*)attribute;

- (void)setProperty:(NSDictionary<NSString*, NSString*> *)dictionary;

- (void)setStyle:(NSDictionary<NSString*, NSString*> *)dictionary;

- (void)addSurround:(NSString *)nodeName attribute:(nullable NSDictionary<NSString*, NSString*> *)attribute;

- (void)deleteCurNode;

- (BOOL)contains:(LKHtmlElement *)element;

- (void)addContent:(NSString *)content;

- (void)addPreSibling:(LKHtmlElement *)element;

@end

NS_ASSUME_NONNULL_END
