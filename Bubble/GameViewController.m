//
//  GameViewController.m
//  Bubble
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 tyq. All rights reserved.
//

#import "GameViewController.h"

#import "AnalyticsViewController.h"
#import "LoginViewController.h"

int score;          //游戏得分
int countTime;      //计时
float yChange;      //纵向偏移量
int xDirection;     //水平偏移方向(0，1)
float xChange;        //水平偏移量

@interface GameViewController ()

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //每次进入游戏界面，重置得分，游戏时间
    score = 0;
    countTime = 60;
    
    self.bubbleArr = [[NSMutableArray alloc] init];
    self.xDirectionArr = [[NSMutableArray alloc] init];
    self.xChangeArr = [[NSMutableArray alloc] init];
    self.yChangeArr = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doBtnStart:(id)sender {
    //启动一个定时器，每0.1秒调用一次，定时器触发的函数是self的timerFunc。userInfo是传入到timerFunc的参数，repeats是标识是否重复调用这个定时器。
    _aniTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
    //启动倒计时定时器
    _timerCount = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
    self.startBtn.enabled = NO;
}

- (IBAction)singleTap:(id)sender {
    //点击bubble 分数+1
    UIImageView *tapIV = (UIImageView *)[(UITapGestureRecognizer *)sender view];
    self.scoreLabel.text = [NSString stringWithFormat:@"分数: %i",++score];
    [tapIV removeFromSuperview];
    for (int i = 0; i < _bubbleArr.count; i++) {
        if ([_bubbleArr objectAtIndex:i] == tapIV) {
            NSLog(@"%i",i);
            [_bubbleArr removeObjectAtIndex:i];
            [_xDirectionArr removeObjectAtIndex:i];
            [_xChangeArr removeObjectAtIndex:i];
            [_yChangeArr removeObjectAtIndex:i];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

//定时器改变bubble位置
- (void)timerFunc {
    for (UIImageView *bubbleImage in self.bubbleArr) {
        int index = [self.bubbleArr indexOfObject:bubbleImage];
        CGPoint center = bubbleImage.center;
        if (bubbleImage.frame.origin.y > 60) {  //如果bubble不在顶端 则继续变化
            //调整纵向位置
            float yChanged =[[self.yChangeArr objectAtIndex:index] floatValue];
            center.y -= yChanged;
            //纵向改变量越来越大
            [self.yChangeArr replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:(yChanged + self.speedSlider.value)]];
            //调整水平位置
            if (bubbleImage.frame.origin.x <= 0) {
                [self.xDirectionArr replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:1]];
                center.x += [[self.xChangeArr objectAtIndex:index] floatValue];
            } else if ((bubbleImage.frame.origin.x + bubbleImage.frame.size.width) >= 320) {
                [self.xDirectionArr replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:0]];
                center.x -= [[self.xChangeArr objectAtIndex:index] floatValue];
            } else if ([[self.xDirectionArr objectAtIndex:index] intValue] == 1) {
                center.x += [[self.xChangeArr objectAtIndex:index] floatValue];
            } else {
                center.x -= [[self.xChangeArr objectAtIndex:index] floatValue];
            }
            //调整ImageView的位置
            bubbleImage.center = center;
            //bubble越来越大
            CGRect frame = bubbleImage.frame;
            frame.size = CGSizeMake((frame.size.width+0.1), (frame.size.height+0.1));
            bubbleImage.frame = frame;
        }
    }
}

//倒计时
- (void)timeCount {
    self.timeLabel.text = [NSString stringWithFormat:@"时间: %i",--countTime];
    if (countTime <= 0) {
        [_aniTimer invalidate];
        [_timerCount invalidate];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Game Over" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AnalyticsViewController *analyticsController = [mainStory instantiateViewControllerWithIdentifier:@"AnalyticsViewController"];
        [self presentViewController:analyticsController animated:YES completion:nil];
    } else {
        //生成新的bubble
        UIImageView *newBubbleIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble.jpg"]];
        [newBubbleIV setFrame:CGRectMake(135, 480, 50, 50)];
        //新的bubble添加点击事件
        newBubbleIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [newBubbleIV addGestureRecognizer:singleTap];
        newBubbleIV.layer.backgroundColor = [UIColor clearColor].CGColor;
        [self.view addSubview:newBubbleIV];
        xDirection = arc4random() % 2;
        xChange = rand()/(double)(RAND_MAX);
        yChange = rand()/(double)(RAND_MAX);
        [self.bubbleArr addObject:newBubbleIV];
        [self.xDirectionArr addObject:[NSNumber numberWithInt:xDirection]];
        [self.xChangeArr addObject:[NSNumber numberWithFloat:xChange]];
        [self.yChangeArr addObject:[NSNumber numberWithFloat:yChange]];
    }
}

+ (int)getScore {
    return score;
}

@end
