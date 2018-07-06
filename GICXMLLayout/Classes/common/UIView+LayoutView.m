//
//  UIView+LayoutView.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "UIView+LayoutView.h"
#import "UIColor+Extension.h"
#import "GDataXMLNode.h"
#import "GICXMLLayout.h"
#import "UIView+GICExtension.h"
#import <objc/runtime.h>

#import "GICColorConverter.h"
#import "GICNumberConverter.h"
#import "GICEdgeConverter.h"
#import "GICStringConverter.h"
#import "GICDataBinding.h"
#import "NSObject+GICDataBinding.h"
#import "NSObject+GICDirective.h"

@implementation UIView (LayoutView)

static NSDictionary<NSString *,GICValueConverter *> *propertyConverts = nil;
+(void)initialize{
    propertyConverts = @{
                         @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [(UIView *)target setBackgroundColor:value];
                         }],
                         @"height":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_Height = [value floatValue];
                         }],
                         @"width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_Width = [value floatValue];
                         }],
                         @"margin":[[GICEdgeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [target setValue:value forKey:@"gic_margin"];
                         }],
                         @"margin-top":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_marginTop = [value floatValue];
                         }],
                         @"margin-left":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_marginLeft = [value floatValue];
                         }],
                         @"margin-right":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_marginRight = [value floatValue];
                         }],
                         @"margin-bottom":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_marginBottom = [value floatValue];
                         }],
                         };
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return propertyConverts;
}

+(NSString *)gic_elementName{
    return nil;
}

-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    for(GDataXMLElement *child in children){
        id childElement = [GICXMLLayout createElement:child];
        if(childElement == nil)
            continue;
        [self gic_addSubElement:childElement];
    }
}

-(NSArray *)gic_subElements{
    return self.subviews;
}

-(void)gic_addSubElement:(NSObject *)subElement{
    if([subElement isKindOfClass:[UIView class]]){
        [self addSubview:(UIView *)subElement];
    }else if ([subElement isKindOfClass:[GICDirective class]]){//如果是指令，那么交给指令自己执行
        [self gic_addDirective:(GICDirective *)subElement];
    }
}

@end