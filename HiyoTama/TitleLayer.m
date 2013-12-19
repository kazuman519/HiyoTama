//
//  TitleLayer.m
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/08/06.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "TitleLayer.h"
#import "GameData.h"
#import "MenuLayer.h"

@implementation TitleLayer
-(id)init{
    if (self=[super init]) {
        
        // レイヤーの初期化
        [self initLayer];
    }
    return self;
}

#pragma mark private

-(void)initLayer{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    GameData *gameData = [GameData getInstance];
    
    // 背景
    NSString *spriteName = [NSString string];
    if (winSize.width == 568) {
        spriteName = @"titleBg-568h@2x.png";
    }else{
        spriteName = @"titleBg.png";
    }
    CCSprite *bgSprite = [CCSprite spriteWithFile:spriteName];
    bgSprite.position = ccp(winSize.width * 0.5, winSize.height * 0.5)
    ;
    [self addChild:bgSprite];
    
    //　タイトルロゴ
    CCSprite *logoSprite = [CCSprite spriteWithFile:@"titleLogo.png"];
    logoSprite.position = ccp(winSize.width * 0.5, winSize.height * 0.75);
    [self addChild:logoSprite];
    
    // ------ メニュー -------
    // スタートボタン
    CCMenuItemSprite *startItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"startBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"startBtn2.png"] block:^(id sender) {
        NSLog(@"START");
        [[SimpleAudioEngine sharedEngine] playEffect:@"kokekoko.mp3"];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MenuLayer node] ]];
    }];
    startItem.position = ccp(winSize.width * 0.5, winSize.height * 0.46);
    
    // その他のゲームボタン
    CCMenuItemSprite *otherGameItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"otherGameBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"otherGameBtn2.png"] block:^(id sender) {
        NSLog(@"OTHER GAME");
    }];
    // まだ利用できないので色変更、たっち不可
    otherGameItem.isEnabled = NO;
    otherGameItem.color = ccGRAY;
    otherGameItem.position = ccp(winSize.width * 0.5, startItem.position.y - startItem.contentSize.height);
    
    //　ボリュームボタン
    volumeItem_ = [CCMenuItemFont itemWithString:@"おと:ON" block:^(id sender) {
        NSLog(@"VOLUME");
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume =0;
        [SimpleAudioEngine sharedEngine].effectsVolume = 0;
        if ([gameData getVolume] > 0) {
            [gameData setVolume:0];
            [volumeItem_ setString:@"おと:OFF"];
        }else{
            [gameData setVolume:1];
            [volumeItem_ setString:@"おと:ON"];
        }
    } ];
    if ([gameData getVolume] == 0) {
        [volumeItem_ setString:@"おと:OFF"];
    }
    volumeItem_.anchorPoint = ccp(0, 0.5);
    volumeItem_.position = ccp(winSize.width - volumeItem_.contentSize.width*0.7,volumeItem_.contentSize.height/2);
    volumeItem_.fontSize = 20;
    volumeItem_.fontName = @"Marker Felt";
    
    // メニュー
    CCMenu *menu = [CCMenu menuWithItems:startItem, otherGameItem, volumeItem_,nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
}
-(void) onEnter
{
	// CCTouchDispatcherに登録します（initメソッド内でコールしても機能しません。）
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
    // 忘れずにスーパークラスのonEnterをコールします
	[super onEnter];
}
-(void)onEnterTransitionDidFinish{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"titleBGM.mp3"];
    [super onEnterTransitionDidFinish];
}
-(void)onExit{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

//---- タッチ処理 ----
// タッチ開始
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL isBlock = NO;
    [[SimpleAudioEngine sharedEngine] playEffect:@"piyo.mp3"];
    
    return isBlock;
}
@end
