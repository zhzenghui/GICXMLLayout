//
//  GICListView.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICListView.h"
#import "NSObject+GICDataContext.h"
#import "GICListItem.h"
#import "GICNumberConverter.h"
#import "GICEdgeConverter.h"
#import "GICBoolConverter.h"
//#import "GICListHeader.h"
//#import "GICListFooter.h"

@interface GICListView ()<ASTableDelegate,ASTableDataSource,GICListItemDelegate>{
    NSMutableArray<GICListItem *> *listItems;
    BOOL t;
    id<RACSubscriber> insertItemsSubscriber;
}
@end

@implementation GICListView
+(NSString *)gic_elementName{
    return @"list";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"separator-style":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICListView *)target gic_safeView:^(id view) {
                     [view setSeparatorStyle:[value integerValue]];
                 }];
             }],
             @"show-ver-scroll":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICListView *)target gic_safeView:^(UIView *view) {
                     [(UIScrollView *)view setShowsVerticalScrollIndicator:[value boolValue]];
                 }];
             }],
             @"show-hor-scroll":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICListView *)target gic_safeView:^(UIView *view) {
                     [(UIScrollView *)view setShowsHorizontalScrollIndicator:[value boolValue]];
                 }];
             }],
             };
}

-(id)init{
    self = [super init];
    listItems = [NSMutableArray array];
    self.dataSource = self;
    self.delegate = self;
    // 创建一个0.2秒的节流阀
    @weakify(self)
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        self->insertItemsSubscriber = subscriber;
        return nil;
    }] bufferWithTime:0.1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        if(self){
            NSInteger index = self->listItems.count;
           
            [self->listItems addObjectsFromArray:[x allObjects]];
            if(index==0){
                [self reloadData];
            }else{
                NSMutableArray *mutArray=[NSMutableArray array];
                for(int i=0 ;i<x.count;i++){
                    [mutArray addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                    index ++;
                }
                [self insertRowsAtIndexPaths:mutArray withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }];

    return self;
}

-(NSArray *)gic_subElements{
    return listItems;
}

-(id)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICListItem class]]){
        [(GICListItem *)subElement setDelegate:self];
        if(!self.isNodeLoaded){
            [listItems addObject:subElement];
        }else{
            [self->insertItemsSubscriber sendNext:subElement];
        }
        return subElement;
    }
    else{
       return [super gic_addSubElement:subElement];
    }
}

-(void)gic_removeSubElements:(NSArray<GICListItem *> *)subElements{
    [super gic_removeSubElements:subElements];
    if(subElements.count==0)
        return;
    NSMutableArray *mutArray=[NSMutableArray array];
    for(id subElement in subElements){
        if([subElement isKindOfClass:[GICListItem class]]){
            [mutArray addObject:[NSIndexPath indexPathForRow:[listItems indexOfObject:subElement] inSection:0]];
        }
    }
    [listItems removeObjectsInArray:subElements];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self->listItems.count==0){
             [self reloadData];
        }else{
            [self deleteRowsAtIndexPaths:mutArray withRowAnimation:UITableViewRowAnimationFade];
        }
    });
}

#pragma mark - ASTableDelegate, ASTableDataSource

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section{
    return listItems.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GICListItem *item = [self->listItems objectAtIndex:indexPath.row];
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        return [item getCell];;
    };
    return cellNodeBlock;
}

-(void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableNode deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}


-(void)dealloc{
    [insertItemsSubscriber sendCompleted];
}
@end
