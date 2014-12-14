//
//  ViewController.m
//  XmasCalendar
//
//  Created by 酒井文也 on 2014/12/13.
//  Copyright (c) 2014年 just1factory. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    int count;
    NSMutableArray *mArray;
    
    //カレンダー表示用メンバ変数
    NSDate *now;
    int year;
    int month;
    int day;
    int maxDay;
    int dayOfWeek;
    
    //カレンダーから取得したものを格納する
    NSUInteger flags;
    NSDateComponents *comps;
    
    int tagNumber;
    NSString *str;
}

//コレクションビュー
@property (strong, nonatomic) IBOutlet UICollectionView *calendarCollection;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mArray = [NSMutableArray new];
    
    //デリゲートを設定
    self.calendarCollection.delegate = self;
    self.calendarCollection.dataSource = self;
    
    //初期値
    tagNumber = 1;
    str = @"";
    
    //現在の日付を取得
    now = [NSDate date];
    
    //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:now];
    
    //最初にメンバ変数に格納するための現在日付の情報を取得する
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    comps = [calendar components:flags fromDate:now];
    
    //年月日と最後の日付を取得(NSIntegerをintへ変換)
    NSInteger orgYear      = comps.year;
    NSInteger orgMonth     = comps.month;
    NSInteger orgDay       = comps.day;
    NSInteger orgDayOfWeek = comps.weekday;
    NSInteger max          = range.length;
    
    year      = (int)orgYear;
    month     = (int)orgMonth;
    day       = (int)orgDay;
    dayOfWeek = (int)orgDayOfWeek;
    
    //月末日(NSIntegerをintへ変換)
    maxDay = (int)max;
    
    //ボタン用の部品配置用の座標を取得する
    [self setupCurrentCalendar];
    
}


//コレクションビューのセル数を取得する
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//コレクションビューのカウント数を取得
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

//コレクションビューのセルに値を格納
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    //ラベル（実際の科目が入る）
    UILabel *calendarBean = (UILabel *)[cell viewWithTag:1];
    
    if(indexPath.row < dayOfWeek - 1){
        
        //日付の入らない部分
        str = @"";
        
    }else if(indexPath.row == dayOfWeek - 1 || indexPath.row < dayOfWeek + maxDay - 1){
        
        //日付の入る部分はボタンのタグを設定する（日にち）
        str = [NSString stringWithFormat:@"%d", tagNumber];
        tagNumber++;
        
    }else if(indexPath.row == dayOfWeek + maxDay - 1 || indexPath.row < 42){
        
        //日付の入らない部分
        str = @"";
    }
    
    calendarBean.text = [NSString stringWithFormat:str,indexPath.row];
    calendarBean.alpha = 1;
    return cell;
}

//ビューセルタップ時の処理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < dayOfWeek - 1){
        
    }else if(indexPath.row == dayOfWeek - 1 || indexPath.row < dayOfWeek + maxDay - 1){
        
        //日付の入る部分はボタンのタグを設定する（日にち）
        targetDetailId = [NSString stringWithFormat:@"%d", indexPath.row];
        [self performSegueWithIdentifier:@"toDetail" sender:targetDetailId];
    
    }else if(indexPath.row == dayOfWeek + maxDay - 1 || indexPath.row < 42){
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //あるビューから複数のセグエが出ている際は行き先を指定しないとダメなのでキッチリ書くこと
    if ([segue.identifier isEqualToString:@"toDetail"]) {
        
        //セグエにtopicIdを入れてあげる
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.detailId = sender;
    }
}

//現在カレンダーのセットアップ
- (void)setupCurrentCalendar
{
    [self setupCurrentCalendarData];
}

//現在の年月に該当するデータを取得
- (void)setupCurrentCalendarData
{
    //inUnitで指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    //該当月の1日の情報を取得する（※カレンダーが始まる場所を取得するため）
    [currentComps setYear:year];
    [currentComps setMonth:month];
    [currentComps setDay:1];
    NSDate *currentDate = [currentCalendar dateFromComponents:currentComps];
    
    //カレンダー情報を再作成する
    [self recreateCalendarParameter:currentCalendar dateObject:currentDate];
}

//カレンダーのパラメータを作成する関数
- (void)recreateCalendarParameter:(NSCalendar *)currentCalendar dateObject:(NSDate *)currentDate
{
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    comps = [currentCalendar components:flags fromDate:currentDate];
    
    NSRange currentRange = [currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
    
    //年月日と最後の日付を取得(NSIntegerをintへ変換)
    NSInteger currentYear      = comps.year;
    NSInteger currentMonth     = comps.month;
    NSInteger currentDay       = comps.day;
    NSInteger currentDayOfWeek = comps.weekday;
    NSInteger currentMax       = currentRange.length;
    
    year      = (int)currentYear;
    month     = (int)currentMonth;
    day       = (int)currentDay;
    dayOfWeek = (int)currentDayOfWeek;
    maxDay    = (int)currentMax;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
