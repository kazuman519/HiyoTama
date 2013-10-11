//
//  PictureBookMenuLayer.m
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/09/17.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "PictureBookMenuLayer.h"
#import "MenuLayer.h"
#import "PictureBookLayer.h"

@implementation PictureBookMenuLayer
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
        spriteName = @"pictureBookBg-568h@2x.png";
    }else{
        spriteName = @"pictureBookBg.png";
    }
    CCSprite *bgSprite = [CCSprite spriteWithFile:spriteName];
    bgSprite.position = ccp(winSize.width * 0.5, winSize.height * 0.5)
    ;
    [self addChild:bgSprite];
    
    
    // ------ メニュー -------
    // メニュー
    menu_ = [CCMenu node];
    menu_.position = ccp(0, 0);
    [self addChild:menu_];
    
    // ボタン
    for (int i = 1; i <= 6; i++) {
        
        NSString *btnString1 = [NSString stringWithFormat:@"btn%d_1.png",i];
        NSString *btnString2 = [NSString stringWithFormat:@"btn%d_2.png",i];
        CCMenuItemSprite *btnItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:btnString1] selectedSprite:[CCSprite spriteWithFile:btnString2] block:^(id sender) {
            
            [gameData setCheckRareLevel:i];
            [[CCDirector sharedDirector] replaceScene:[PictureBookLayer node]];
            NSLog(@"%d",i);
        }];
        btnItem.position = ccp(winSize.width/2 - btnItem.contentSize.width/2 + (btnItem.contentSize.width*1.02 * ((i-1) % 2)), winSize.height * 0.7 - (btnItem.contentSize.height * ((i-1) / 2)));
        [menu_ addChild:btnItem];
    }
    
    // 戻るボタン
    CCMenuItemSprite *returnItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"returnMenuBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"returnMenuBtn2.png"] block:^(id sender) {
        
        // ボタンを押したときのアクション
        NSLog(@"RETURN TITLE");
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MenuLayer node] ]];
    }];
    returnItem.scale = 0.8;
    returnItem.anchorPoint = ccp(1.0, 0.0);
    returnItem.position = ccp(winSize.width, 0);
    [menu_ addChild:returnItem];
}
@end
