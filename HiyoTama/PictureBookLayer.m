//
//  PictureBookLayer.m
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/08/15.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "PictureBookLayer.h"
#import "PictureBookMenuLayer.h"
#import "Hiyo.h"
#import "DetailsView.h"

@implementation PictureBookLayer
-(id)init{
    if (self=[super init]) {
        winSize_ = [[CCDirector sharedDirector] winSize];
        gameData_ = [GameData getInstance];
        
        // 初期化
        self.hiyoNumberArray = [gameData_ getHiyoNumberArrayAppointRare:[gameData_ getCheckRareLevel]];
        self.labelArray = [NSMutableArray array];
        
        // レイヤーの初期化
        [self initLayer];
        [self positionHiyoSprite];
    }
    return self;
}

#pragma mark private

-(void)initLayer{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    view_ = [[UIView alloc]
                    initWithFrame:CGRectMake(0, 0, winSize.width, winSize.height)];
    [[[CCDirector sharedDirector] view] addSubview:view_];
    
    scrollView_ = [[UIScrollView alloc]init];
    scrollView_.frame = view_.bounds;
    // スクロールしたときバウンドさせないようにする
    scrollView_.bounces = NO;
    // UIScrollViewのインスタンスをビューに追加
    [view_ addSubview:scrollView_];
    
    // 表示されたときスクロールバーを点滅
    [scrollView_ flashScrollIndicators];
    
    
    // UIImageViewのインスタンス化
    // サンプルとして画面に収まりきらないサイズ
    
    UIImage *bgImage = [UIImage alloc];
    CGRect rect = CGRectMake(0, 0, winSize_.width, bgImage.size.height);
    if (winSize.width == 568) {
        bgImage = [UIImage imageNamed:[NSString stringWithFormat:@"pictureBookBg%d-568h@2x.png",[gameData_ getCheckRareLevel]]];
        rect = CGRectMake(0, 0, winSize_.width, bgImage.size.height/2);
    }else{
        bgImage = [UIImage imageNamed:[NSString stringWithFormat:@"pictureBookBg%d.png",[gameData_ getCheckRareLevel]]];
        rect = CGRectMake(0, 0, winSize_.width, bgImage.size.height);
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    
    // 画像を設定
    imageView.image = bgImage;
    
    // UIScrollViewのインスタンスに画像を貼付ける
    [scrollView_ addSubview:imageView];
    // UIScrollViewのコンテンツサイズを画像のサイズに合わせる
    scrollView_.contentSize = imageView.bounds.size;
    
    // 捕獲率
    int kindSum = 0;
    for (NSNumber* hiyoNum in self.hiyoNumberArray){
        int hiyoSum = [gameData_ getHiyoSumAppointNumber:hiyoNum.intValue];
        NSLog(@"num%@ sum%d",hiyoNum,hiyoSum);
        if (hiyoSum > 0) {
            kindSum++;
        }
    }
    UILabel *sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(winSize_.width/2 + winSize_.height*0.26, winSize.height * 0.087, 80, 25)];
    sumLabel.text = [NSString stringWithFormat:@"%d",kindSum];
    sumLabel.font = [UIFont fontWithName:@"Marker Felt" size:28];
    sumLabel.textAlignment = UITextAlignmentRight;
    sumLabel.textColor = [UIColor blackColor];
    sumLabel.backgroundColor = [UIColor clearColor];
    [scrollView_ addSubview:sumLabel];
    
    // 戻るボタン
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *returnBtnImg = [UIImage imageNamed:@"returnPBMenuBtn1.png"];
    returnBtn.center = CGPointMake(winSize_.width - returnBtnImg.size.width, winSize.height - returnBtnImg.size.height);
    [returnBtn setImage:returnBtnImg forState:UIControlStateNormal];
    [returnBtn sizeToFit];
    [returnBtn addTarget:self
                  action:@selector(returnAction)
        forControlEvents:UIControlEventTouchUpInside];
    [view_ addSubview:returnBtn];
}
-(void)returnAction{
    [view_ removeFromSuperview];
    [[SimpleAudioEngine sharedEngine] playEffect:@"return.wav"];
    [[CCDirector sharedDirector] replaceScene:[PictureBookMenuLayer node]];
}

-(void) onEnter
{
    // 忘れずにスーパークラスのonEnterをコールします
	[super onEnter];
}

-(void) onExit
{	
	// 忘れずにスーパークラスのonExitをコールします
	[super onExit];
}

// ひよを配置する
-(void)positionHiyoSprite{
    int i = 0;
    for (NSNumber *num in self.hiyoNumberArray){
        // ひよをボタン化
        UIButton *hiyoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *hiyoImgName = [NSString string];
        if ([gameData_ getHiyoSumAppointNumber:num.intValue] > 0) {
            hiyoImgName = [NSString stringWithFormat:@"hiyo%d.png",num.intValue];
        }
        else{
            hiyoImgName = @"hiyo0.png";
            [hiyoBtn setEnabled:NO];
        }
        UIImage *hiyoImg = [UIImage imageNamed:hiyoImgName];
        //リサイズ
        float scale = 0.73;
        CGSize sz = CGSizeMake(hiyoImg.size.width*scale,
                               hiyoImg.size.height*scale);
        UIGraphicsBeginImageContext(sz);
        [hiyoImg drawInRect:CGRectMake(0, 0, sz.width, sz.height)];
        hiyoImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSLog(@"%f",winSize_.width*0.17);
        hiyoBtn.center = CGPointMake(winSize_.width/2 - winSize_.height*0.76 -hiyoImg.size.width/2 + winSize_.height*0.27 + winSize_.height*0.323*(i%4), -hiyoImg.size.height/2 + winSize_.height*0.35 + winSize_.height*0.33*(i/4));
        hiyoBtn.tag = num.intValue;
        [hiyoBtn setImage:hiyoImg forState:UIControlStateNormal];
        [hiyoBtn sizeToFit];
        [hiyoBtn addTarget:self
                      action:@selector(touchHiyoAcriton:)
            forControlEvents:UIControlEventTouchUpInside];
        [scrollView_ addSubview:hiyoBtn];
        
        NSString *labelString = [NSString string];
        if (![gameData_ getIsFirstCheckHiyo:num.intValue] && [gameData_ getHiyoSumAppointNumber:num.intValue] > 0) {
            // 確認していないひよにはNEWをつける
            labelString = @"NEW!!";
        }
        else{
            labelString = @"";
        }
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(hiyoBtn.center.x - winSize_.height*0.125, hiyoBtn.center.y - winSize_.height*0.14, 80, 25)];
        newLabel.text = labelString;
        newLabel.font = [UIFont fontWithName:@"Marker Felt" size:20];
        newLabel.textAlignment = UITextAlignmentRight;
        newLabel.textColor = [UIColor redColor];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.transform = CGAffineTransformMakeRotation(0.3);
        [scrollView_ addSubview:newLabel];
        [self.labelArray addObject:newLabel];
        
        i++;
    }
}
-(void)touchHiyoAcriton:(id)sender{
    [[SimpleAudioEngine sharedEngine] playEffect:@"tap.wav"];
    UIButton *btn = sender;
    DetailsView *detailsView = [[DetailsView alloc] init];
    [detailsView setDetails:btn.tag];
    
    NSNumber *firstNum = [self.hiyoNumberArray objectAtIndex:0];
    NSLog(@"%d",firstNum.intValue);
    int labelIndex =btn.tag - firstNum.intValue;
    UILabel *label = [self.labelArray objectAtIndex:labelIndex];
    label.text = @"";
}

@end
