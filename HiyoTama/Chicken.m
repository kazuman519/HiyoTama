//
//  Chicken.m
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/08/06.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "Chicken.h"

@implementation Chicken

@synthesize isTouch = isTouch_;

enum {
    OBJECT_NULL,
    OBJECT_EGG,
    OBJECT_CHICKEN
};

-(id)init{
    if (self=[super init]) {
        winSize_ = [[CCDirector sharedDirector] winSize];
        gameData_ = [GameData getInstance];
        
        //ゲームデータのスコア初期化
        [gameData_ resetGameData];
        
        // 値の初期化
        scale_ = 0.8;
        isTouch_ = NO;
        isFever_ = NO;
        isTouchEnabled_ = NO;
        feverEggProbability_ = [gameData_ getFeverEggProbability];
        feverTime_ = 0.0f;
        maxFeverTime_ = [gameData_ getMaxFeverTime];
        self.eggArray = [NSMutableArray array];
        self.probabilityArray = [gameData_ getProbabilityArray];
        self.feverProArray = [NSMutableArray array];
        
        float plusPro = 0.0f;
        for (int i = 0; i < self.probabilityArray.count; i++) {
            if (i > 21) {
                // レア度3以上のひよの確率をあげる
                NSNumber *probability = [self.probabilityArray objectAtIndex:i];
                NSNumber *lastPro = [self.probabilityArray objectAtIndex:i-1];
                plusPro += (probability.floatValue - lastPro.floatValue)*3;
                float feverPro = probability.floatValue + plusPro;
                NSLog(@"i=%d  pro=%f fever=%f",i,probability.floatValue,feverPro);
                [self.feverProArray addObject:[NSNumber numberWithFloat:feverPro]];
            }else{
                [self.feverProArray addObject:[self.probabilityArray objectAtIndex:i]];
            }
        }
        
        // 画像の設定
        sprite_ = [CCSprite spriteWithFile:@"chicken.png"];
        sprite_.scale = scale_;
        sprite_.anchorPoint = ccp(0.5, 0.0);
        sprite_.position = ccp(sprite_.contentSize.width/2, 50);
        [self addChild:sprite_ z:OBJECT_CHICKEN tag:OBJECT_CHICKEN];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) onEnter
{
	// CCTouchDispatcherに登録します（initメソッド内でコールしても機能しません。）
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
    // 忘れずにスーパークラスのonEnterをコールします
	[super onEnter];
}

-(void) onExit
{
	// CCTouchDispatcherから登録を削除します
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	
	// 忘れずにスーパークラスのonExitをコールします
	[super onExit];
}

-(void)dealloc{
    [super dealloc];
}

// 更新
-(void)update:(ccTime)delta{
    // 画面外にでた卵の削除
    NSMutableArray *deleteArray = [NSMutableArray array];
    for (Egg* egg in self.eggArray){
        if (egg.position.x >= winSize_.width + egg.contentSize.width) {
            [self removeChild:egg];
            [deleteArray addObject:egg];
        }
    }
    [self.eggArray removeObjectsInArray:deleteArray];
    [deleteArray removeAllObjects];
}

// ----- チキンのモードを設定するインスタンスメソッド -----
// ゲームモード
-(void)setGameMode{
    isTouchEnabled_ = YES;
}
// リザルトモード
-(void)setResultMode{
    isTouchEnabled_ = NO;
    
    if (isFever_) {
        [self returnNormalAction];
    }
    
    // 後ろをむいてひよを迎えにいくアクション
    id delay = [CCDelayTime actionWithDuration:0.5];
    id tween1 = [CCActionTween actionWithDuration:0.5 key:@"scaleX" from:scale_ to:-scale_];
    id jumpTo1 = [CCJumpTo actionWithDuration:1.0 position:ccp(winSize_.width + sprite_.contentSize.width, 50) height:winSize_.height * 0.1 jumps:15];
    id sequence1 = [CCSequence actions:delay, tween1, jumpTo1, nil];
    
    // ひよをひきつれて戻ってくるアクション
    id tween2 = [CCActionTween actionWithDuration:0.5 key:@"scaleX" from:-scale_ to:scale_];
    id jumpTo2 = [CCJumpTo actionWithDuration:3.0 position:ccp(-sprite_.contentSize.width, 50) height:winSize_.height * 0.1 jumps:10];
    id blockHiyo = [CCCallBlock actionWithBlock:^{
        // ひよをうむ
        [self createHiyoAction];
    }];
    id spawn = [CCSpawn actions:jumpTo2, blockHiyo, nil];
    id sequence2 = [CCSequence actions: sequence1,tween2, spawn, nil];
    [sprite_ runAction:sequence2];
    
    // 取得数を登録
    [gameData_ updateSumOfDB:gameData_.eggSumArray];
}

// 卵を産むアクション
-(void)layEggAction{
    NSMutableArray *proArray = self.probabilityArray;
    //　スコア加算
    [gameData_ addScore:1];
    
    if (isFever_) {
        // フィーバーだった場合は確率をあげる配列を使う
        proArray = self.feverProArray;
    }
    NSNumber *proNum = [proArray lastObject];
    float randomValue = CCRANDOM_0_1() * proNum.floatValue;
    float touchEggRandomValue = CCRANDOM_0_1();
    
    Egg *egg = [Egg node];
    
    if (touchEggRandomValue <= feverEggProbability_ && !isFever_) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"pon1.wav"];
        // ナンバー１が登録される
        [gameData_ addEggSumArray:1];
        [egg setFever];
        
        [self surpriseAction];
    }
    else{
        [[SimpleAudioEngine sharedEngine] playEffect:@"pon2.wav"];
        int eggNumber = 1;
        for (NSNumber *proNum in proArray){
            if (randomValue <= proNum.floatValue) {
                [egg setStatus:eggNumber];
                if ([gameData_ getHiyoRareAppointNumber:eggNumber] >= 3) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"koke.mp3"];
                    [self surpriseAction];
                }
                break;
            }
            eggNumber++;
        }
        [gameData_ addEggSumArray:eggNumber];
    }
    
    [egg moveRightAction:sprite_.position];
    [self addChild:egg z:OBJECT_EGG tag:OBJECT_EGG];
    [self.eggArray addObject:egg];
}

// 卵からひよを返す
-(void)createHiyoAction{
    NSArray *array = [gameData_ getEggSumArray];
    float createSum = 1;
    for (int number = array.count; number > 0; number--){
        NSNumber *sumNumber = [array objectAtIndex:number-1];
        if (sumNumber.intValue > 0) {
            id delay = [CCDelayTime actionWithDuration:createSum / 4.0f + 0.4];
            id block = [CCCallBlock actionWithBlock:^{
                Hiyo *hiyo = [Hiyo node];
                [hiyo setStatus:number];
                [hiyo moveLeftAction];
                [self addChild:hiyo];
                
                // 初めて出る日よだった場合はNEWをつける
                if ([gameData_ getHiyoSumAppointNumber:number] == sumNumber.intValue) {
                    [hiyo setNewLabel];
                }
            }];
            id sequence = [CCSequence actions:delay, block, nil];
            
            [self runAction:sequence];
            
            createSum++;
        }
    }
}

// びっくりするアクション
-(void)surpriseAction{
    CCAnimation *animation = [CCAnimation animation];
    [animation addSpriteFrameWithFilename:@"chicken_surprise.png"];
    [animation addSpriteFrameWithFilename:@"chicken.png"];

    animation.delayPerUnit = 0.5;
    animation.loops = 1;
    CCAnimate* animate = [CCAnimate actionWithAnimation:animation];
    [sprite_ runAction:animate];
}
// ノーマルにもどるアクション
-(void)returnNormalAction{
    [self stopFeverParticle];
    [sprite_ stopAllActions];
    // アニメーション
    CCAnimation *animation = [CCAnimation animation];
    [animation addSpriteFrameWithFilename:@"chicken.png"];
    animation.delayPerUnit = 0.2;
    animation.loops = 0;
    CCAnimate* animate = [CCAnimate actionWithAnimation:animation];
    [sprite_ runAction:animate];
    
    [self unschedule:@selector(feverTimerUpdate:)];
    isFever_ = NO;
    feverTime_ = 0.0;
    
    id scaleTo = [CCScaleTo actionWithDuration:0.2 scale:scale_];
    [sprite_ runAction:scaleTo];
}
// フィーバーアクション
-(void)feverAction{
    [[SimpleAudioEngine sharedEngine] playEffect:@"kokekoko.mp3"];
    [sprite_ stopAllActions];
    // アニメーション
    CCAnimation *animation = [CCAnimation animation];
    [animation addSpriteFrameWithFilename:@"chicken_fever1.png"];
    [animation addSpriteFrameWithFilename:@"chicken_fever2.png"];
    animation.delayPerUnit = 0.2;
    animation.loops = -1;
    CCAnimate* animate = [CCAnimate actionWithAnimation:animation];
    [sprite_ runAction:animate];
    
    sprite_.scale = 1.0;
    
    [self feverParticle];
    [self schedule:@selector(feverTimerUpdate:)];
}
-(void)feverTimerUpdate:(ccTime)delta{
    feverTime_+=delta;
    
    if (feverTime_ >= maxFeverTime_) {
        [self returnNormalAction];
    }
}

//---- タッチ処理 ----
// タッチ開始
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL isBlock = NO;
    
    // タッチ座標を、cocos2d座標に変換します
    CGPoint touchLocation = [touch locationInView:touch.view];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    // にわとりをタッチしたとき
    if (CGRectContainsPoint(sprite_.boundingBox, location) && isTouchEnabled_){
        [self layEggAction];
        isTouch_ = YES;
        
        if (isFever_) {
            id delay = [CCDelayTime actionWithDuration:0.05];
            id func = [CCCallFunc actionWithTarget:self selector:@selector(layEggAction)];
            id sequence = [CCSequence actions:delay, func, nil];
            [self runAction:sequence];
        }
        isBlock = YES;
    }
    
    // 卵をタッチしたとき
    for (Egg *egg in self.eggArray){
        if (CGRectContainsPoint(egg.sprite.boundingBox, location) && !isFever_ && isTouchEnabled_) {
            if (egg.isFeverEgg && egg.isTouchEnabled) {
                isFever_ = YES;
                [self feverAction];
                [egg touchFeverEgg];
                NSLog(@"FEVER");
            }
        }
    }
    
    return isBlock;
}
// タッチ中移動
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
}
// タッチ終了
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    isTouch_ = NO;
}

// フィーバーパーティクル
-(void)feverParticle{
   feverPs = [CCParticleSystemQuad particleWithFile:@"feverChicken.plist"];
    feverPs.position = ccp(sprite_.position.x, sprite_.position.y + sprite_.contentSize.height * 0.2);
    feverPs.autoRemoveOnFinish = YES;
    [self addChild:feverPs];
}
-(void)stopFeverParticle{
    [self removeChild:feverPs];
}
@end
