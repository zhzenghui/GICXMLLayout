//
//  GICNavBar.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import "GICNavBar.h"
#import "GICPage.h"
#import "GICStringConverter.h"

@implementation GICNavBar
+(NSString *)gic_elementName{
    return @"nav-bar";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"title":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [GICUtils mainThreadExcu:^{
                     [[((GICNavBar *)target)->navbar topItem] setTitle:value];
                 }];
                 
             }],
             //             @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
             //                 [((GICPage *)target)->viewNode setBackgroundColor:value];
             //             }],
             };
}

-(id)init{
    self = [super init];
    
    return self;
}

-(void)gic_beginParseElement:(GDataXMLElement *)element withSuperElement:(GICPage *)superElment{
    NSAssert([superElment isKindOfClass:[GICPage class]], @"nav-bar 必须是page的子元素");
    [GICUtils mainThreadExcu:^{
        self->navbar = superElment.navigationController.navigationBar;
    }];
    [super gic_beginParseElement:element withSuperElement:superElment];
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    if([element.name isEqualToString:@"right-buttons"]){
        _rightButtons = [GICNavbarButtons new];
        return self.rightButtons;
    }else if([element.name isEqualToString:@"left-buttons"]){
        _leftButtons = [GICNavbarButtons new];
        return self.leftButtons;
    }
    return [super gic_parseSubElementNotExist:element];
}

-(void)gic_parseElementCompelete{
    [GICUtils mainThreadExcu:^{
        NSMutableArray *rightItems = [NSMutableArray array];
        for(ASDisplayNode *node in self.rightButtons.buttons){
            node.frame = CGRectMake(0, 0, node.style.width.value, 44);
            [rightItems addObject:[[UIBarButtonItem alloc] initWithCustomView:node.view]];
        }
        self->navbar.topItem.rightBarButtonItems = rightItems;
        
        
        
        NSMutableArray *leftItems = [NSMutableArray array];
        for(ASDisplayNode *node in self.leftButtons.buttons){
            node.frame = CGRectMake(0, 0, node.style.width.value, 44);
            [leftItems addObject:[[UIBarButtonItem alloc] initWithCustomView:node.view]];
        }
        
        if(leftItems.count>0){
            self->navbar.topItem.leftBarButtonItems = leftItems;
        }
    }];
}

-(void)dealloc{
    
}
@end
