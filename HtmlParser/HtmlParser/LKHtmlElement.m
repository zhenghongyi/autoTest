//
//  LKHtmlElement.m
//  HtmlParser
//
//  Created by zhenghongyi on 2019/1/11.
//  Copyright © 2019 Coremail. All rights reserved.
//

#import "LKHtmlElement.h"

#import "XPathHandler.h"

@interface LKHtmlElement() {
    xmlNodePtr _node;
    NSString* _encoding;
}

@property (nonatomic, copy, readwrite) NSString* html;

@property (nonatomic, copy, readwrite) NSString* innerHtml;

@property (nonatomic, copy, readwrite) NSString* nodeName;

@property (nonatomic, copy, readwrite) NSDictionary* attribute;

@end

@implementation LKHtmlElement

- (instancetype)initWithNode:(xmlNodePtr)node encoding:(nullable NSString *)encoding {
    self = [super init];
    if (self) {
        _node = node;
        _encoding = encoding;
    }
    return self;
}

+ (instancetype)create:(NSString *)nodeName attribute:(NSDictionary<NSString*, NSString*>*)attribute {
    xmlNodePtr node = CreateNode(nodeName, attribute);
    if (node != nil) {
        return [[LKHtmlElement alloc] initWithNode:node encoding:nil];
    }
    return nil;
}

- (NSString *)html {
    if (!_html) {
        _html = HtmlForNode(_node);
    }
    return _html;
}

- (NSString *)innerHtml {
    if (!_innerHtml) {
        NSUInteger beginLocation = [self.html rangeOfString:@">"].location;
        NSUInteger endLocation = [self.html rangeOfString:@"<" options:NSBackwardsSearch].location;
        if (beginLocation != NSNotFound && endLocation != NSNotFound) {
            return [self.html substringWithRange:NSMakeRange(beginLocation + 1, endLocation - beginLocation)];
        }
    }
    return _innerHtml;
}

- (NSString *)nodeName {
    if (!_nodeName) {
        NSDictionary* dic = DictionaryForNode(_node);
        _nodeName = [dic objectForKey:@"nodeName"];
    }
    return _nodeName;
}

- (NSDictionary *)attribute {
    if (!_attribute) {
        _attribute = AttributeForNode(_node);
    }
    return _attribute;
}

- (NSDictionary *)style {
    NSString* styleStr = [self.attribute objectForKey:@"style"];
    if (styleStr) {
        NSMutableDictionary* styleDic = [NSMutableDictionary dictionary];
        styleStr = [styleStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray* array = [styleStr componentsSeparatedByString:@";"];
        for (NSString* item in array) {
            NSArray* itemArr = [item componentsSeparatedByString:@":"];
            if (itemArr.count < 2) {
                continue;
            }
            if ([itemArr.firstObject isEqualToString:@""]) {
                continue;
            }
            
            [styleDic setObject:itemArr.lastObject forKey:itemArr.firstObject];
        }
        return styleDic;
    }
    return nil;
}

- (NSArray<LKHtmlElement *> *)children {
    NSMutableArray* array = [NSMutableArray array];
    xmlNodePtr childNode = _node->children;
    while (childNode) {
        LKHtmlElement* childElement = [[LKHtmlElement alloc] initWithNode:childNode encoding:_encoding];
        [array addObject:childElement];
        
        childNode = childNode->next;
    }
    
    return array;
}

- (void)setProperty:(NSDictionary<NSString*, NSString*> *)dictionary {
    SetPropertyForNode(_node, dictionary);
}

- (void)setStyle:(NSDictionary<NSString*, NSString*> *)dictionary {
    NSMutableString* styleStr = [NSMutableString string];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [styleStr appendFormat:@"%@:%@;", key, obj];
    }];
    [self setProperty:@{@"style":styleStr}];
}

- (void)addSurround:(NSString *)nodeName attribute:(NSDictionary<NSString*, NSString*> *)attribute {
    SurroundNode(_node, nodeName, attribute);
}

- (void)deleteCurNode {
    DeleteNode(_node);
}

- (BOOL)contains:(LKHtmlElement *)element {
    xmlNodePtr parentNode = element->_node->parent;
    while (parentNode) {
        if (parentNode == _node) {
            return true;
        }
        parentNode = parentNode->parent;
    }
    return false;
}

- (void)addContent:(NSString *)content {
    if (content) {
        AddContent(_node, content);
    }
}

- (void)addPreSibling:(LKHtmlElement *)element {
    AddPrevSibling(_node, element->_node);
}

@end
