//
//  PlayHelpLayer.m
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/12/19.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "PlayHelpLayer.h"
#import "CCScrollLayer.h"
#import "MenuLayer.h"

enum{
    OBJECT_SCROLL,
    OBJECT_TITLE
};

@implementation PlayHelpLayer
-(id)init{
    if (self=[super init]) {
        winSize_ = [[CCDirector sharedDirector] winSize];
        
        // レイヤーの初期化
        CCSprite *titleSprite = [CCSprite spriteWithFile:@"playHelp.png"];
        titleSprite.anchorPoint = ccp(0.5, 1.0);
        titleSprite.position = ccp(winSize_.width/2, winSize_.height);
        [self addChild:titleSprite z:OBJECT_TITLE];
        
        NSMutableArray *layerArray = [NSMutableArray array];
        CCLayer *layer1 = [CCLayer node];
        CCLayer *layer2 = [CCLayer node];
        [layerArray addObject:layer1];
        [layerArray addObject:layer2];
        
        CCSprite *playSprite1 = [CCSprite spriteWithFile:@"playImage1.png"];
        playSprite1.position = ccp(winSize_.width/2, winSize_.height/2);
        [layer1 addChild:playSprite1];
        CCSprite *playSprite2 = [CCSprite spriteWithFile:@"playImage2.png"];
        playSprite2.position = ccp(winSize_.width/2, winSize_.height/2);
        [layer2 addChild:playSprite2];
        
        // CCScrollLayerに突っ込む
        CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:layerArray widthOffset:0];
        scroller.pagesIndicatorPosition = ccp(winSize_.width/2, 20);
        [self addChild:scroller z:OBJECT_SCROLL];
        
        // 戻るボタン
        CCMenuItemSprite *returnItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"returnMenuBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"returnMenuBtn2.png"] block:^(id sender) {
            
            // ボタンを押したときのアクション
            NSLog(@"RETURN TITLE");
            [[SimpleAudioEngine sharedEngine] playEffect:@"return.wav"];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MenuLayer node] ]];
        }];
        returnItem.scale = 0.8;
        returnItem.anchorPoint = ccp(1.0, 0.0);
        returnItem.position = ccp(winSize_.width, 0);
        
        CCMenu *menu = [CCMenu menuWithItems:returnItem, nil];
        menu.position = ccp(0, 0);
        [self addChild:menu];
    }
    return self;
}
@end
