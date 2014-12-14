//
//  ViewController.h
//  XmasCalendar
//
//  Created by 酒井文也 on 2014/12/13.
//  Copyright (c) 2014年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DetailViewController.h"

//コレクションビューデリゲートを設定
@interface ViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSString *targetDetailId;
}

@property (nonatomic ,strong) NSString *detailId;

@end

