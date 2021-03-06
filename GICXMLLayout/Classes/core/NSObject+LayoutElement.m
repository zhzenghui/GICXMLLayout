//
//  NSObject+LayoutView.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/3.
//

#import "NSObject+LayoutElement.h"
#import "GICXMLLayout.h"
#import "GICStringConverter.h"
#import "NSObject+GICDataBinding.h"
#import <objc/runtime.h>
#import "NSObject+GICTemplate.h"
#import "GICTemplateRef.h"
#import "GICDataContextConverter.h"
#import "GICElementsCache.h"
#import "NSObject+GICStyle.h"


@implementation NSObject (LayoutElement)

-(GICNSObjectExtensionProperties *)gic_ExtensionProperties{
    GICNSObjectExtensionProperties *v =objc_getAssociatedObject(self, "gic_ExtensionProperties");
    if(!v){
        v = [GICNSObjectExtensionProperties new];
        objc_setAssociatedObject(self, "gic_ExtensionProperties", v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return v;
}

+(NSString *)gic_elementName{
    return nil;
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"name":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 target.gic_ExtensionProperties.name = value;
             }],
             @"data-path":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [target setGic_dataPathKey:value];
             }],
             @"data-context":[[GICDataContextConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 target.gic_ExtensionProperties.tempDataContext = value;
             }]
             };;
}

-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    NSInteger order = 0;
    for(GDataXMLElement *child in children){
        NSObject *childElement = [NSObject gic_createElement:child withSuperElement:self];
        if(childElement == nil){
            childElement = [self gic_parseSubElementNotExist:child];
            [childElement gic_beginParseElement:child withSuperElement:self];
        }
        if(childElement == nil)
            continue;
        childElement.gic_ExtensionProperties.elementOrder = order;
        [self gic_addSubElement:childElement];
        order++;
    }
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    return nil;
}

-(id)gic_addSubElement:(NSObject *)subElement{
    if ([subElement isKindOfClass:[GICBehavior class]]){//如果是指令，那么交给指令自己执行
        [self gic_addBehavior:(GICBehavior *)subElement];
    }else if ([subElement isKindOfClass:[GICTemplates class]]){
        GICTemplates *ts = (GICTemplates *)subElement;
        if(self.gic_templates){
            [self.gic_templates.templats addEntriesFromDictionary:ts.templats];
        }else{
            self.gic_templates = ts;
        }
        // 将模板加入临时上下文中
        [[[GICXMLParserContext currentInstance] currentTemplates] addEntriesFromDictionary:ts.templats];
    }else if ([subElement isKindOfClass:[GICTemplateRef class]]){
        // 模板引用
        GICTemplateRef *tr = (GICTemplateRef *)subElement;
        if(![tr gic_self_dataContext]){
            tr.gic_DataContenxt = self.gic_DataContenxt;
        }
        NSObject *el = [tr parseTemplateFromTarget:self];
        el.gic_isAutoInheritDataModel = tr.gic_isAutoInheritDataModel;
        el.gic_DataContenxt = tr.gic_DataContenxt;
        el.gic_ExtensionProperties.elementOrder = tr.gic_ExtensionProperties.elementOrder;
        [self gic_addSubElement:el];
        return el;
    }else if ([subElement isKindOfClass:[GICBehaviors class]]){ //行为
        for(GICBehavior *b in ((GICBehaviors *)subElement).behaviors){
            b.gic_ExtensionProperties.superElement = self;
            [self gic_addBehavior:b];
        }
    }else if ([subElement isKindOfClass:[GICStyle class]]){ //行为
        self.gic_style = (GICStyle *)subElement;
    }else{
        return nil;
    }
    return subElement;
}

-(id)gic_insertSubElement:(id)subElement elementOrder:(NSInteger)order{
    ((NSObject *)subElement).gic_ExtensionProperties.elementOrder = order;
    [self gic_addSubElement:subElement];
    return subElement;
}


-(void)gic_beginParseElement:(GDataXMLElement *)element withSuperElement:(id)superElment{
    [self gic_ExtensionProperties].superElement = superElment;
    [self gic_parseAttributes:element];
    if([self gic_isAutoCacheElement]){
        [[superElment gic_ExtensionProperties] addSubElement:self];
    }
    // 解析子元素
    if([self respondsToSelector:@selector(gic_parseSubElements:)]){
        NSArray *children = element.children;
        if(children.count>0 && [children[0] isKindOfClass:[GDataXMLElement class]]){// 添加后面这个判断主要是为了解决某些标签在有结束标签的时候添加了换行，有可能会出现解析出错。
            // 检查是否支持单个子元素
            if([self respondsToSelector:@selector(gic_parseOnlyOneSubElement)] && [(id)self gic_parseOnlyOneSubElement]){
                NSAssert1(children.count <= 1, @"%@只支持单个子元素", element.name);
                if(children.count!=1){
                    return;
                }
            }
            [(id)self gic_parseSubElements:element.children];
        }
    }
    [self performSelector:@selector(gic_parseElementCompelete)];
}

-(void)gic_parseAttributes:(GDataXMLElement *)element{
    // convert attributes
    NSMutableDictionary<NSString *, NSString *> *attributeDict=[self gic_mergeStyles:element];
    NSDictionary *ps = [GICElementsCache classAttributs:[self class]];
    for(NSString *key in attributeDict.allKeys){
        NSString *value = [attributeDict objectForKey:key];
        GICAttributeValueConverter *converter = [ps objectForKey:key];
        if(converter){
            if([value hasPrefix:@"{{"] && [value hasSuffix:@"}}"]){
                NSString *expression = [value stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{} "]];
                GICDataBinding *binding = [GICDataBinding createBindingFromExpression:expression];
                binding.attributeValueConverter = converter;
                binding.target = self;
                binding.attributeName = key;
                [self gic_addBinding:binding];
                continue;
            }
            converter.propertySetter(self, [converter convert:value]);
        }
    }
}

-(void)gic_parseElementCompelete{
    for(GICBehavior *b in self.gic_Behaviors.behaviors){
        [b attachTo:self];
    }
    id temp = self.gic_ExtensionProperties.tempDataContext;
    if(temp){
        self.gic_DataContenxt = temp;
        self.gic_ExtensionProperties.tempDataContext = nil;
        self.gic_isAutoInheritDataModel = NO;
    }
}

- (BOOL)gic_parseOnlyOneSubElement {
    return NO;
}


-(id)gic_getSuperElement{
    return self.gic_ExtensionProperties.superElement;
}

-(NSArray *)gic_subElements{
    return self.gic_ExtensionProperties.subElements;
}
-(void)gic_removeSubElements:(NSArray<NSObject *> *)subElements{
    [self.gic_ExtensionProperties removeSubElements:subElements];
}

-(BOOL)gic_isAutoCacheElement{
    return YES;
}

-(id)gic_findSubElementFromName:(NSString *)name{
    id findEl = nil;
    for(NSObject *obj in [self gic_subElements]){
        if([obj.gic_ExtensionProperties.name isEqualToString:name]){
            findEl = obj;
        }
    }
    
    if(findEl==nil){
        for(NSObject *obj in [self gic_subElements]){
            findEl = [obj gic_findSubElementFromName:name];
        }
    }
    return findEl;
}

+(NSObject *)gic_createElement:(GDataXMLElement *)element withSuperElement:(id)superElement{
    NSString *elementName = element.name;
    Class c = [GICElementsCache classForElementName:elementName];
    if(c){
        NSObject *v = [c new];
        [v gic_beginParseElement:element withSuperElement:superElement];
        return v;
    }
    return nil;
}
@end
