//
//  XPathHandler.h
//  HtmlParser
//
//  Created by zhenghongyi on 2019/1/11.
//  Copyright © 2019 Coremail. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <libxml/tree.h>
#import <libxml/parser.h>
#import <libxml/HTMLparser.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>

NSString* HtmlForNode(xmlNodePtr node);

NSDictionary* DictionaryForNode(xmlNodePtr currentNode);

NSDictionary* AttributeForNode(xmlNodePtr currentNode);

xmlXPathObjectPtr SearchXPathObj(NSString* query, xmlXPathContextPtr xpathCtx);

void SetPropertyForNode(xmlNodePtr node, NSDictionary<NSString*, NSString*>*dictionary);

void SurroundNode(xmlNodePtr node, NSString* nodeName, NSDictionary<NSString*, NSString*>* nodeAttribute);

void DeleteNode(xmlNodePtr node);

void AddContent(xmlNodePtr node, NSString* content);

xmlNodePtr CreateNode(NSString* nodeName, NSDictionary<NSString*, NSString*>* attribute);

void AddPrevSibling(xmlNodePtr curNode, xmlNodePtr node);
