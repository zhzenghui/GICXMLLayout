//
//  GICListItem.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import <UIKit/UIKit.h>

@class GICListItem;

@protocol GICListItemDelegate

@end

@interface GICListItem : NSObject{
//    CGFloat itemHeight;//lsit-item的固定高度
    
    CGFloat _cellAutoHeight;//自动计算的高度
}
//@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,strong,readonly)NSString *identifyString;

@property (nonatomic,readonly) NSMutableDictionary *cellStyle;

@property (nonatomic,weak)id<GICListItemDelegate> delegate;
@property (nonatomic,strong)GDataXMLDocument *xmlDoc;
@property (nonatomic,strong)GICEvent *itemSelectEvent;

-(ASCellNode *)getCell;
@end
