//
//  DetailsView.m
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/09/20.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "DetailsView.h"


@implementation DetailsView
-(id)init{
    if (self = [super init]) {
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        gameData_ = [GameData getInstance];
        
        view_ = [[UIView alloc]
                        initWithFrame:CGRectMake(0, 0, winSize.width, winSize.height)];
        [[[CCDirector sharedDirector] view] addSubview:view_];
        
        UIImage *bgImage = [UIImage imageNamed:@"detailsBg.png"];
        bgView_ = [[UIImageView alloc]initWithFrame:CGRectMake(winSize.width/2 - bgImage.size.width/2, winSize.height/2 - bgImage.size.height/2, bgImage.size.width, bgImage.size.height)];
        bgView_.image = bgImage;
        [view_ addSubview:bgView_];
        
        // ボタンを作成
        UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *returnBtnImg = [UIImage imageNamed:@"returnPBBtn.png"];
        returnBtn.center = CGPointMake(bgView_.center.x + bgImage.size.width/2 - returnBtnImg.size.width, bgView_.center.y - bgImage.size.height/2);
        [returnBtn setImage:returnBtnImg forState:UIControlStateNormal];
        [returnBtn sizeToFit];
        [returnBtn addTarget:self
                   action:@selector(removeAction)
         forControlEvents:UIControlEventTouchUpInside];
        [view_ addSubview:returnBtn];
        
        //[self setDetails:2];
    }
    return self;
}

-(void)removeAction{
    NSLog(@"kieru");
    [[SimpleAudioEngine sharedEngine] playEffect:@"return.wav"];
    [view_ removeFromSuperview];
}

-(void)setDetails:(int)hiyoNum{
    Hiyo *hiyo = [Hiyo node];
    [hiyo setStatus:hiyoNum];
    
    // ひよ画像
    UIImage *hiyoImg = [UIImage imageNamed:[NSString stringWithFormat:@"hiyo%d.png",hiyoNum]];
    UIImageView *hiyoView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView_.center.x - bgView_.image.size.width*0.4, bgView_.center.y - bgView_.image.size.height * 0.2, hiyoImg.size.width, hiyoImg.size.height)];
    hiyoView.image = hiyoImg;
    [view_ addSubview:hiyoView];
    
    //　卵画像
    UIImage *eggImg = [UIImage imageNamed:[NSString stringWithFormat:@"egg%d.png",hiyoNum]];
    UIImageView *eggView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView_.center.x - bgView_.image.size.width*0.14, bgView_.center.y - bgView_.image.size.height * 0.32, eggImg.size.width, eggImg.size.height)];
    eggView.image = eggImg;
    [view_ addSubview:eggView];
    
    // ナンバー
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView_.center.x - bgView_.image.size.width*0.4, bgView_.center.y - bgView_.image.size.height * 0.5, 100, 25)];
    numLabel.text = [NSString stringWithFormat:@"%d",hiyoNum];
    numLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.backgroundColor = [UIColor clearColor];
    [view_ addSubview:numLabel];
    
    // 名前
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView_.center.x + bgView_.image.size.width*0.08, bgView_.center.y - bgView_.image.size.height * 0.45, 100, 25)];
    nameLabel.text = [hiyo getName];
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.backgroundColor = [UIColor clearColor];
    [view_ addSubview:nameLabel];
    
    // レア度
    UILabel *rareLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView_.center.x + bgView_.image.size.width*0.1, bgView_.center.y - bgView_.image.size.height * 0.276, 120, 25)];
    rareLabel.text = [NSString stringWithFormat:@"%d",[hiyo getRare]];
    rareLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    rareLabel.textAlignment = UITextAlignmentCenter;
    rareLabel.textColor = [UIColor blackColor];
    rareLabel.backgroundColor = [UIColor clearColor];
    [view_ addSubview:rareLabel];
    
    // 捕獲数
    UILabel *sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView_.center.x + bgView_.image.size.width*0.1, bgView_.center.y - bgView_.image.size.height * 0.1, 120, 25)];
    sumLabel.text = [NSString stringWithFormat:@"%d",[hiyo getSum]];
    sumLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    sumLabel.textAlignment = UITextAlignmentCenter;
    sumLabel.textColor = [UIColor blackColor];
    sumLabel.backgroundColor = [UIColor clearColor];
    [view_ addSubview:sumLabel];
    
    // 説明文
    UILabel *explLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView_.center.x + bgView_.image.size.width*0.05, bgView_.center.y + bgView_.image.size.height * 0.1, 110, 0)];
    explLabel.text = [hiyo getExpalanation];
    explLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    explLabel.textColor = [UIColor blackColor];
    explLabel.numberOfLines = 3;
    explLabel.lineBreakMode  = NSLineBreakByCharWrapping;
    explLabel.backgroundColor = [UIColor clearColor];
    [explLabel sizeToFit];
    [view_ addSubview:explLabel];
    
    // NEWがついていたばあいみたことにする
    if (![gameData_ getIsFirstCheckHiyo:hiyoNum]) {
        [gameData_ setFirstCheckHiyoNum:hiyoNum];
    }
}
@end
