//
//  GameData.h
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/08/03.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface GameData : CCNode {
    @private
    NSUserDefaults *gameDataDefaults_;
    NSString *gameVersionKey_;
    NSString *volumeKey_;
    NSString *staminaKey_;
    NSString *setTimeKey_;
    NSString *highScoreKey_;
    NSString *firstCheckHiyoKey_;
    
    int maxStamina_;
    int recoveryTime_;
    int useStaminaValue_;
    float gameTime_;
    float feverEggProbability_;
    float maxFeverTime_;
    
    // ゲーム中のデータ
    int score_;
    
    // 図鑑でのデータ
    int checkRareLevel_;
    
    //SQLiteデータベースの名前とパス
    NSString *databaseName_;
}

@property (nonatomic, retain) NSMutableArray *probabilityArray;
@property (nonatomic, retain) NSMutableArray *eggSumArray;
@property (nonatomic, retain) NSString *databasePath;

+(GameData*)getInstance;

-(void)resetGameData;

-(void)setGameVersion:(float)version;
-(void)setNowTime;
-(void)setVolume:(int)volume;
-(void)setStamina:(int)stamina;
-(void)setSetTime:(NSDate*)date;
-(void)setHighScore:(int)score;
-(void)setCheckRareLevel:(int)rare;
-(void)setFirstCheckHiyoNum:(int)number;

-(void)addScore:(int)score;
-(void)addEggSumArray:(int)number;

-(void)useStamina;

-(float)getGameVersion;
-(NSDate*)getSetTime;
-(int)getVolume;
-(int)getStamina;
-(int)getMaxStamina;
-(int)getUseStaminaValue;
-(float)getGameTime;
-(float)getFeverEggProbability;
-(float)getMaxFeverTime;
-(int)getScore;
-(int)getHighScore;
-(int)getCheckRareLevel;
-(BOOL)getIsFirstCheckHiyo:(int)number;
-(NSMutableArray*)getProbabilityArray;
-(NSMutableArray*)getEggSumArray;

// データベース関連のメソッド
-(void)updateSumOfDB:(NSMutableArray*)array;

-(NSString*)getHiyoNameAppointNumber:(int)number;
-(int)getHiyoRareAppointNumber:(int)number;
-(NSString*)getHiyoKindAppointNumber:(int)number;
-(int)getHiyoSumAppointNumber:(int)number;
-(NSString*)getHiyoExplanationAppointNumber:(int)number;
-(NSMutableArray*)getHiyoNumberArrayAppointRare:(int)rare;

@end
