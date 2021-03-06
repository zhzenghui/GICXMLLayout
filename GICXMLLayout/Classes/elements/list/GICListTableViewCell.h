//
//  GICListTableViewCell.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import <UIKit/UIKit.h>
#import "GICListItem.h"
#import "GICPanel.h"

@interface GICListTableViewCell : ASCellNode{
    RACDisposable *layoutSubviewsSignlDisposable;//专门用来设置layoutSubviewsSignl的释放器。为了在cell重新的过程中，不会因为多个数据源共用一个cell从而导致height计算的错误
    GICPanel *panel;
//    RACDisposable *itemSelectedSignlDisposable;
    
}

@property (nonatomic,weak)GICListItem *listItem;
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *descriptionNode;

-(id)initWithListItem:(GICListItem *)listItem;
@end
