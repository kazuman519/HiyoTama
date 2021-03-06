//
//  GameLayer.m
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/08/03.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "GameLayer.h"
#import "MenuLayer.h"

enum {
    OBJECT_NULL,
    OBJECT_CHICKEN,
    OBJECT_TIMER,
    OBJECT_SCORE,
    OBJECT_TOUCH,
    OBJECT_NOTIFY
};

@implementation GameLayer
-(id)init{
    if (self=[super init]) {
        // 初期化
        winSize_ = [[CCDirector sharedDirector] winSize];
        gameData_ = [GameData getInstance];
        
        gameTime_ = [gameData_ getGameTime];
        isGameEnd_ = NO;
        isShowTouch_ = YES;
        
        [self initLayer];
        
        chicken_ = [[[Chicken alloc] init] autorelease];
        [self addChild:chicken_ z:OBJECT_CHICKEN];
    }
    return self;
}

-(void) onEnterTransitionDidFinish
{
    // 忘れずにスーパークラスのonEnterをコールします
	[super onEnterTransitionDidFinish];
    
    [self gameStart];
    
    // 広告の表示
    adLayer_ = [AdLayer layer];
    [self addChild:adLayer_];
}

-(void) onExit
{
    NSLog(@"GameLayer Exit");
    [adLayer_ removeAd];
	
	// 忘れずにスーパークラスのonExitをコールします
	[super onExit];
}


#pragma mark private

-(void)initLayer{
    GameData *gameData = [GameData getInstance];
    
    // 背景
    NSString *spriteName = [NSString string];
    if (winSize_.width == 568) {
        spriteName = @"gameBg-568h@2x.png";
    }else{
        spriteName = @"gameBg.png";
    }
    CCSprite *bgSprite = [CCSprite spriteWithFile:spriteName];
    bgSprite.position = ccp(winSize_.width * 0.5, winSize_.height * 0.5)
    ;
    [self addChild:bgSprite];
    
    // タイマー
    CCSprite *timerSprite = [CCSprite spriteWithFile:@"timerImage.png"];
    timerSprite.anchorPoint = ccp(0.0, 1.0);
    timerSprite.position = ccp(0, winSize_.height);
    [self addChild: timerSprite z:OBJECT_TIMER];
    
    timerLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%2.0f",gameTime_] fontName:@"Marker Felt" fontSize:25];
    //timerLabel_.color = ccBLACK;
    timerLabel_.anchorPoint = ccp(0, 1.0);
    timerLabel_.position = ccp(timerSprite.position.x + timerSprite.contentSize.width*0.5, timerSprite.position.y - timerSprite.contentSize.height*0.2);
    [self addChild:timerLabel_];
    
    // タッチ
    touchSprite_ = [CCSprite spriteWithFile:@"touchImage.png"];
    touchSprite_.anchorPoint = ccp(0.5, 0);
    touchSprite_.position = ccp(chicken_.position.x + winSize_.height*0.25, chicken_.position.y + winSize_.height*0.7);
    touchSprite_.scale = 0.7;
    [self addChild:touchSprite_ z:OBJECT_TOUCH tag:OBJECT_TOUCH];
    [self jumpAction:touchSprite_];
    
    // スコアを表示するラベル
    scoreLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%dコ",[gameData getScore]] fontName:@"Marker Felt" fontSize:25];
    //scoreLabel_.color = ccBLACK;
    scoreLabel_.anchorPoint = ccp(1.0,1.0);
    scoreLabel_.position = ccp(winSize_.width, winSize_.height);
    [self addChild:scoreLabel_ z:OBJECT_SCORE tag:OBJECT_SCORE];
}
-(void)jumpAction:(CCNode*)node{
    id jumpBy = [CCJumpBy actionWithDuration:10 position:ccp(0, 0) height:20 jumps:30];
    [node runAction:jumpBy];
}

// ----- ゲーム制御部分　-----
// ゲームスタート
-(void)gameStart{
    CCSprite *startSprite = [CCSprite spriteWithFile:@"gameStart.png"];
    startSprite.position = ccp(winSize_.width * 0.5, winSize_.height * 0.5);
    startSprite.scale = 0.0;
    [self addChild:startSprite z:OBJECT_NOTIFY];
    
    id scaleTo = [CCScaleTo actionWithDuration:0.2 scale:1.0];
    id rotateTo = [CCRotateTo actionWithDuration:0.2 angle:720];
    id spawn = [CCSpawn actions:scaleTo, rotateTo, nil];
    id block = [CCCallBlock actionWithBlock:^{
        // ゲーム開始時のアクション
        [self scheduleUpdate];
        [self schedule:@selector(timerPlay:)];
        NSLog(@"ゲーム開始！");
        [[SimpleAudioEngine sharedEngine] playEffect:@"start.wav"];
        [chicken_ setGameMode];
    }];
    id delay = [CCDelayTime actionWithDuration:0.5];
    id tween = [CCActionTween actionWithDuration:0.5 key:@"opacity" from:255 to:0];
    id sequence = [CCSequence actions:spawn, block, delay, tween, nil];
    
    [startSprite runAction:sequence];
}
// ゲームエンド
-(void)gameEnd{
    GameData *gameData = [GameData getInstance];
    isGameEnd_ =YES;
    [self unschedule:@selector(timerPlay:)];
    [self unscheduleUpdate];
    NSLog(@"ゲーム終了！");
    [[SimpleAudioEngine sharedEngine] playEffect:@"finish.wav"];
    
    // フィニッシュ画像
    CCSprite *endSprite = [CCSprite spriteWithFile:@"gameEnd.png"];
    endSprite.position = ccp(winSize_.width * 0.5, winSize_.height * 0.5);
    endSprite.scale = 0.0;
    [self addChild:endSprite z:OBJECT_NOTIFY];
    
    // 遅延時間の計算
    int delayValue = 0;
    for (NSNumber *num in [gameData getEggSumArray]){
        if (num.intValue > 0) {
            delayValue++;
        }
    }
    
    id scaleTo = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    id block = [CCCallBlock actionWithBlock:^{
        // ゲーム終了時のアクション
        [chicken_ setResultMode];
    }];
    id delay = [CCDelayTime actionWithDuration:0.5];
    id tween = [CCActionTween actionWithDuration:0.5 key:@"opacity" from:255 to:0];
    id returnDelay = [CCDelayTime actionWithDuration:3.0+delayValue/2];
    id returnBlock = [CCCallBlock actionWithBlock:^{
        // メニュー画面に戻る
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"titleBGM.mp3"];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MenuLayer node] ]];
    }];
    id sequence = [CCSequence actions:scaleTo, block, delay, tween, returnDelay, returnBlock, nil];
    
    [endSprite runAction:sequence];
    
    id scaleTo1 = [CCScaleTo actionWithDuration:0.5 scale:2];
    id tint = [CCTintTo actionWithDuration:0.5 red:100 green:100 blue:100];
    id spawn = [CCSpawn actions:scaleTo1, tint, nil];
    [scoreLabel_ runAction:spawn];
    
    // ハイスコアの更新
    NSLog(@"socre%d high%d",[gameData getScore],[gameData getHighScore]);
    if ([gameData getScore] > [gameData getHighScore]) {
        [gameData setHighScore:[gameData getScore]];
    }
}

// ゲーム上のデータを更新するメソッド
-(void)update:(ccTime)delta{
    GameData *gameData = [GameData getInstance];
    
    [scoreLabel_ setString:[NSString stringWithFormat:@"%dコ",[gameData getScore]]];
}

// タイマーを動かすメソッド
-(void)timerPlay:(ccTime)dt{
    if (!isGameEnd_) {
        gameTime_ -= dt;
        if (gameTime_ < 0.0) {
            gameTime_ = 0.0;
            
            // ゲーム終了
            [self gameEnd];
        }
        [timerLabel_ setString:[NSString stringWithFormat:@"%2.1f",gameTime_]];
    }
    if (chicken_.isTouch && isShowTouch_) {
        isShowTouch_ = NO;
        // にわとりがたっちされたらタッチをけす
        id delay = [CCDelayTime actionWithDuration:0.8];
        id block = [CCCallBlock actionWithBlock:^{
            [touchSprite_ stopAllActions];
            id scaleTo = [CCScaleTo actionWithDuration:0.4 scale:0];
            [touchSprite_ runAction:scaleTo];
        }];
        [self runAction:[CCSequence actions:delay, block, nil]];
    }
}
@end
