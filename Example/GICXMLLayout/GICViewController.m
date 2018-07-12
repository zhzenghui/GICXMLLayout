//
//  GICViewController.m
//  GICXMLLayout
//
//  Created by ghwghw4 on 07/02/2018.
//  Copyright (c) 2018 ghwghw4. All rights reserved.
//

#import "GICViewController.h"
#import <GDataXMLNode_GIC/GDataXMLNode.h>
#import "GICXMLLayout.h"
#import "IndexPageViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface GICViewController (){
      ASTextNode *_node;
}

@end

@implementation GICViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    NSMutableDictionary *temp2data = [@{@"obj":[@{@"name":@"hello word 111",@"loc1":@"西湖",@"loc2":@"青园小区哈哈",@"clickCount":@(20),@"url":@"http://ppt.downhot.com/d/file/p/2014/07/24/afd8b2135086cc9f2787d114bd73005a.png"} mutableCopy],@"datas":@[@{@"name":@"hello word 222",@"loc1":@"西湖",@"loc2":@"青园小区哈哈",@"clickCount":@(20),@"url":@"http://ppt.downhot.com/d/file/p/2014/07/24/afd8b2135086cc9f2787d114bd73005a.png"},@{@"name":@"hello word 333",@"loc1":@"西湖",@"loc2":@"青园小区哈哈",@"clickCount":@(20),@"url":@"http://ppt.downhot.com/d/file/p/2014/07/24/afd8b2135086cc9f2787d114bd73005a.png"}]} mutableCopy];
    
    
    NSMutableArray *temp3Data = [NSMutableArray array];
    for(int i=0;i<10;i++){
        [temp3Data addObject:@{@"name":[NSString stringWithFormat:@"hello word 111 ::: %@",@(i)],@"loc1":@"西湖",@"loc2":@"青园小区哈哈",@"clickCount":@(20),@"url":@"http://ppt.downhot.com/d/file/p/2014/07/24/afd8b2135086cc9f2787d114bd73005a.png",@"id":@(1)}];
        [temp3Data addObject:@{@"name":[NSString stringWithFormat:@"hello word 222 ::: %@",@(i)],@"loc1":@"西湖",@"loc2":@"青园小区哈哈",@"clickCount":@(20),@"url":@"http://ppt.downhot.com/d/file/p/2014/07/24/afd8b2135086cc9f2787d114bd73005a.png",@"id":@(2)}];
    }
    
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12.0f] };
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"1\n2\n3\n4\n5" attributes:attrs];
    
    _node = [[ASTextNode alloc] init];
    _node.maximumNumberOfLines = 3;
    _node.backgroundColor = [UIColor lightGrayColor];
    _node.attributedText = string;
    _node.frame = CGRectMake(70, 400, 40, 100);
    [self.view addSubnode:_node];
    
//    // Do any additional setup after loading the view, typically from a nib.
//    NSData *xmlData = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/template5.xml"]];
////    [GICXMLLayout parseLayoutView:xmlData toView:self.view withParseCompelete:^(UIView *view) {
////        view.gic_DataContenxt = [IndexPageViewModel new];
////    }];
//
//    [GICXMLLayout parseLayoutView:xmlData toView:self.view withParseCompelete:^(UIView *view) {
//
//    }];
  
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[data objectForKey:@"obj"] setValue:@"1231231会hiuhuihiuhiuhiuhiuhuihiuhiuhiuhiuhiuh2" forKey:@"name"];
//        [[data objectForKey:@"obj"] setValue:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530767605274&di=09dc516c16904f4c0af6b73ce0bf2bf7&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F0823dd54564e92584fbb491f9082d158cdbf4eb0.jpg" forKey:@"url"];
//         [[data objectForKey:@"obj"] setValue:@(30) forKey:@"clickCount"];
//        [data setValue:@{@"name":@"hhhhhhhhh",@"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530767605274&di=09dc516c16904f4c0af6b73ce0bf2bf7&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F0823dd54564e92584fbb491f9082d158cdbf4eb0.jpg"} forKey:@"obj"];
        
//        for(int i=0;i<3;i++){
//            [temp3Data addObject:@{@"name":@"hello word 111",@"loc1":@"西湖",@"loc2":@"青园小区哈哈",@"clickCount":@(20),@"url":@"http://ppt.downhot.com/d/file/p/2014/07/24/afd8b2135086cc9f2787d114bd73005a.png"}];
//        }
        
//        [temp3Data addObjectsFromArray:[temp3Data copy]];
    });
    
//    RACSignal *siganl = [RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]];
//   __block int a=10;
//    //定时器执行代码
//    [siganl subscribeNext:^(id x) {
//        a++;
//        [temp3Data addObject:@{@"name":[NSString stringWithFormat:@"hello word %@",@(a)],@"loc1":@"西湖",@"loc2":@"青园小区哈哈",@"clickCount":@(20),@"url":@"http://ppt.downhot.com/d/file/p/2014/07/24/afd8b2135086cc9f2787d114bd73005a.png"}];
//    }];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
