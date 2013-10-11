//
//  Hiyo.h
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/08/15.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameData.h"

@interface Hiyo : CCNode {
    @private
    CGSize winSize_;
    GameData *gameData_;
    
    CCSprite *sprite_;
    int number_;
    NSString *name_;
    int rare_;
    NSString *kind_;
    int sum_;
    NSString *explanation_;
    
    CCLabelTTF* newLabel_;
}

-(void)setStatus:(int)number;
-(void)setPosition:(CGPoint)position;
-(int)getNumber;
-(NSString*)getName;
-(int)getRare;
-(NSString*)getKind;
-(int)getSum;
-(NSString*)getExpalanation;

-(void)moveLeftAction;
-(void)setNewLabel;
@end
