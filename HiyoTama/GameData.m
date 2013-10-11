//
//  GameData.m
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/08/03.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "GameData.h"

@implementation GameData

static GameData* _gameDataInstance = nil;

+ (GameData*)getInstance{
    if (_gameDataInstance != nil) {
        return _gameDataInstance;
    }else{
        _gameDataInstance = [[GameData alloc] init];
        return _gameDataInstance;
    }
}

-(id)init{
    if (self=[super init]) {
        
        // 値の初期化
        gameDataDefaults_ = [NSUserDefaults standardUserDefaults];
        staminaKey_ = @"STAMINA";
        setTimeKey_ = @"SET_TIME";
        highScoreKey_ = @"HIGH_SCORE";
        maxStamina_ = 60;
        recoveryTime_ = 3*60;
        useStaminaValue_ = 3;
        gameTime_ = 10.0f;
        feverEggProbability_ = 0.01f;
        maxFeverTime_ = 3.0;
        
        checkRareLevel_ = 0;
        
        self.probabilityArray = [NSMutableArray array];
        self.eggSumArray = [NSMutableArray array];
        [self resetGameData];
        
        //データベースの選択
        databaseName_ = @"hiyoDataBase.sqlite";
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentDir = [documentPaths objectAtIndex:0];
        self.databasePath = [documentDir stringByAppendingPathComponent:databaseName_];
        
        [self createAndCheckDatabase];
        [self registerProbabilityArray];
        
        // 初期起動チェック
        NSDate* setDate = [gameDataDefaults_ objectForKey:setTimeKey_];
        if (setDate == NULL) {
            // 初期時間のセット
            NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
            [inputDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            NSDate* initDate = [inputDateFormatter dateFromString:@"2000/01/01 00:00:01"];
            [self setSetTime:initDate];
            NSLog(@"初期時刻 -> %@", initDate);
            [inputDateFormatter release];
        }
        NSLog(@"GameData Init");
    }
    return self;
}


// ------ データベース関連 -----
-(void) createAndCheckDatabase {
    
    BOOL success;
    
    //databasePathにデータベースファイルがあるか確認
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:self.databasePath];
    
    //もしあれば、処理中断
    if(success){
        NSLog(@"あったあああ");
        return;
    }
    
    //プロジェクトフォルダからサンドボックスへコピー
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName_];
    [fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:nil];
}

// たまごの出る確率を配列に登録
-(void)registerProbabilityArray{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    NSLog(@"%@",self.databasePath);
    [db open];
    
    //クエリ文を指定
    NSString *select_query = [NSString stringWithFormat:@"SELECT probability FROM hiyos"];
    [db beginTransaction];
    
    FMResultSet *rs = [db executeQuery:select_query];
    
    float probabilitySum = 0.0f;
    while([rs next]) {
        probabilitySum += [rs doubleForColumn:@"probability"];
        [self.probabilityArray addObject:[NSNumber numberWithFloat:probabilitySum]];
    }
    [db close];
    
    float proSum = 0.0f;
    for (NSNumber *proNum in self.probabilityArray){
        proSum += proNum.floatValue;
        NSLog(@"pro %f",proNum.floatValue);
    }
    NSLog(@"ごうけいはこれだ！ %f",proSum);
}

// データベースに1ゲームででた卵の数を登録する
-(void)updateSumOfDB:(NSMutableArray*)array{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    int hiyoNumber = 1;
    for (NSNumber *num in array){
        NSString *update_query = [NSString stringWithFormat:@"UPDATE hiyos SET sum = sum + %d WHERE id = %d;", num.intValue, hiyoNumber];
        
        //クエリ開始
        [db beginTransaction];
        //クエリ実行
        [db executeUpdate:update_query];
        //Databaseへの変更確定
        [db commit];
        
        hiyoNumber++;
    }
    [db close];
}

// ----- データを取得するメソッド ----
// ひよの名前を取得
-(NSString*)getHiyoNameAppointNumber:(int)number{
    NSString* name = [NSString string];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    NSString *select_query = [NSString stringWithFormat:@"SELECT * FROM hiyos WHERE id = %d",number];
    [db beginTransaction];
    
    FMResultSet *rs = [db executeQuery:select_query];
    [rs next];
    name = [rs stringForColumn:@"name"];

    [db close];
    
    return name;
}

// ひよのレア度を取得
-(int)getHiyoRareAppointNumber:(int)number{
    int rare;
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    NSString *select_query = [NSString stringWithFormat:@"SELECT * FROM hiyos WHERE id = %d",number];
    [db beginTransaction];
    
    FMResultSet *rs = [db executeQuery:select_query];
    [rs next];
    rare = [rs intForColumn:@"rare"];
    
    [db close];
    
    return rare;
}

// ひよの説明文を取得
-(NSString*)getHiyoKindAppointNumber:(int)number{
    NSString* kind = [NSString string];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    NSString *select_query = [NSString stringWithFormat:@"SELECT * FROM hiyos WHERE id = %d",number];
    [db beginTransaction];
    
    FMResultSet *rs = [db executeQuery:select_query];
    [rs next];
    kind = [rs stringForColumn:@"kind"];
    
    [db close];
    
    return kind;
}

// ひよの獲得数を取得
-(int)getHiyoSumAppointNumber:(int)number{
    int sum;
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    NSString *select_query = [NSString stringWithFormat:@"SELECT * FROM hiyos WHERE id = %d",number];
    [db beginTransaction];
    
    FMResultSet *rs = [db executeQuery:select_query];
    [rs next];
    sum = [rs intForColumn:@"sum"];
    
    [db close];
    
    return sum;
}

// ひよの説明文を取得
-(NSString*)getHiyoExplanationAppointNumber:(int)number{
    NSString* explanation = [NSString string];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    NSString *select_query = [NSString stringWithFormat:@"SELECT * FROM hiyos WHERE id = %d",number];
    [db beginTransaction];
    
    FMResultSet *rs = [db executeQuery:select_query];
    [rs next];
    explanation = [rs stringForColumn:@"explanation"];
    
    [db close];
    
    return explanation;
}

// レア度を指定してそのレア度のひよの番号を配列にいれて返す
-(NSMutableArray*)getHiyoNumberArrayAppointRare:(int)rare{
    NSMutableArray *hiyoNumberArray = [NSMutableArray array];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    NSString *select_query = [NSString stringWithFormat:@"SELECT * FROM hiyos WHERE rare = %d",rare];
    [db beginTransaction];
    
    FMResultSet *rs = [db executeQuery:select_query];
    
    while ([rs next]) {
        [hiyoNumberArray addObject:[NSNumber numberWithInt:[rs intForColumn:@"id"]]];
    }
    [db close];
    
    return hiyoNumberArray;
}

// データベース内のデータを参照する
-(void)selectDB {
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    //クエリ文を指定
    NSString *select_query = [NSString stringWithFormat:@"SELECT * FROM hiyos"];
    [db beginTransaction];
    
    FMResultSet *rs = [db executeQuery:select_query];
    NSLog(@"id:name:rare:kind:sum:explanation:probability");
    while([rs next]) {
        NSLog(@"%d:%@:%d:%@:%d:%@:%f:", [rs intForColumn:@"id"],[rs stringForColumn:@"name"], [rs intForColumn:@"rare"],[rs stringForColumn:@"kind"],[rs intForColumn:@"sum"],[rs stringForColumn:@"explanation"],[rs doubleForColumn:@"probability"]);
    }
    //Databaseを閉じる
    [db close];
}


-(void)dealloc{
    [super dealloc];
}

-(void)resetGameData{
    score_ = 0;
    NSNumber *num = [NSNumber numberWithInt:0];
    [self.eggSumArray removeAllObjects];
    for (int i = 0; i < self.probabilityArray.count; i++) {
        [self.eggSumArray addObject:num];
    }
}

// セットするメソッド
-(void)setNowTime{
    NSDate *date = [NSDate date];
    [gameDataDefaults_ setObject:date forKey:setTimeKey_];
}
-(void)setStamina:(int)stamina{
    NSNumber *num = [NSNumber numberWithInt:stamina];
    [gameDataDefaults_ setObject:num forKey:staminaKey_];
}
-(void)setSetTime:(NSDate *)date{
    [gameDataDefaults_ setObject:date forKey:setTimeKey_];
}
-(void)setHighScore:(int)score{
    NSLog(@"setHighScore %d",score);
    [gameDataDefaults_ setInteger:score forKey:highScoreKey_];
}
-(void)setCheckRareLevel:(int)rare{
    checkRareLevel_ = rare;
}

// 加えるメソッド
-(void)addScore:(int)score{
    score_ += score;
}
-(void)addEggSumArray:(int)number{
    NSNumber *nowEggSumNum = [self.eggSumArray objectAtIndex:number-1];
    int eggSum = nowEggSumNum.intValue + 1;
    [self.eggSumArray replaceObjectAtIndex:number-1 withObject:[NSNumber numberWithInt:eggSum]];
}

// 消費するメソッド
-(void)useStamina{
    int stamina = [self getStamina];
    if (stamina == maxStamina_){
        [self setNowTime];
    }
    [self setStamina:stamina-useStaminaValue_];
}

// 取得するメソッド
-(NSDate*)getSetTime{
    NSDate *date = [gameDataDefaults_ objectForKey:setTimeKey_];
    return date;
}
-(int)getStamina{
    NSNumber* staminaNum = [gameDataDefaults_ objectForKey:staminaKey_];
    int stamina = staminaNum.intValue;
    
    // ------ アップデート部分 -------
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
	[inputDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *nowDate = [NSDate date];
    NSDate *setDate = [self getSetTime];
    // dateBとdateAの時間の間隔を取得(dateB - dateAなイメージ)
	NSTimeInterval  since = [nowDate timeIntervalSinceDate:setDate];
    
    while (since>=recoveryTime_ && stamina < maxStamina_) {
        setDate = [setDate initWithTimeInterval:recoveryTime_ sinceDate:setDate];
        [self setSetTime:setDate];
        since = [nowDate timeIntervalSinceDate:setDate];
        stamina++;
        [self setStamina:stamina];
    }
	[inputDateFormatter release];
    // -------------------
    
    return stamina;
}
-(int)getMaxStamina{
    return maxStamina_;
}
-(int)getUseStaminaValue{
    return useStaminaValue_;
}
-(float)getGameTime{
    return gameTime_;
}
-(float)getFeverEggProbability{
    return feverEggProbability_;
}
-(float)getMaxFeverTime{
    return maxFeverTime_;
}
-(int)getScore{
    return score_;
}
-(int)getHighScore{
    int highScore = [gameDataDefaults_ integerForKey:highScoreKey_];
    return highScore;
}
-(int)getCheckRareLevel{
    return checkRareLevel_;
}
-(NSMutableArray*)getProbabilityArray{
    return self.probabilityArray;
}
-(NSMutableArray*)getEggSumArray{
    return self.eggSumArray;
}
@end
