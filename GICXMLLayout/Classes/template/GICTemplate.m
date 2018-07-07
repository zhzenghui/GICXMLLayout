//
//  GICTemplate.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import "GICTemplate.h"
#import "GICStringConverter.h"

@implementation GICTemplate
+(NSString *)gic_elementName{
    return @"template";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return @{
             @"t-name":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICTemplate *)target setName:value];
             }]
             };;
}

-(BOOL)gic_parseOnlyOneSubElement{
    return YES;
}

-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    if(children.count==1){
        self->xmlDoc = [[GDataXMLDocument alloc] initWithRootElement:children[0]];
    }
}

-(NSObject *)createElement{
    NSObject *childElement = [GICXMLLayout createElement:[self->xmlDoc rootElement]];
    return childElement;
}
@end