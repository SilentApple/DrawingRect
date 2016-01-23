//
//  ViewController.m
//  SilentAppleDrawingRect
//
//  Created by qiaos on 16/1/20.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *playButton;

// 标记按钮播放状态的flag
@property (nonatomic, assign) BOOL isPlaying;
// 有动画的layer
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.playButton.layer.cornerRadius = CGRectGetWidth(self.playButton.frame) / 2;
    self.playButton.layer.masksToBounds = YES;
    self.playButton.layer.borderColor = [UIColor cyanColor].CGColor;
    self.playButton.layer.borderWidth = 2.0;
}

- (IBAction)resetAction:(id)sender {
    // 如果shapeLayer在父视图上,则将其从父视图上移除
    if (self.shapeLayer.superlayer) {
        [self.shapeLayer removeFromSuperlayer];
        [self playButtonAction:self.playButton];
    }
}

- (IBAction)playButtonAction:(UIButton *)sender {
    self.isPlaying = !self.isPlaying;
    if (self.isPlaying) {
        // 正在播放
        [sender setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        // 如果没在视图上,则将layer添加到视图上
        if (!self.shapeLayer.superlayer) {
            [self createLayer];
        } else {
            [self resume];
        }
        
    } else {
        // 暂停
        [sender setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [self pause];
    }
}

// 暂停
- (void)pause {
    CFTimeInterval pauseTime = [self.shapeLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 速度置0,使其暂停
    self.shapeLayer.speed = 0.0;
    self.shapeLayer.timeOffset = pauseTime;
}

// 继续
- (void)resume {
    CFTimeInterval pauseTime = [self.shapeLayer timeOffset];
    // 恢复速度
    self.shapeLayer.speed = 1.0;
    self.shapeLayer.timeOffset = 0.0;
    self.shapeLayer.beginTime = 0.0;
    CFTimeInterval sinceTime = [self.shapeLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    // 设置重新开始时间
    self.shapeLayer.beginTime = sinceTime;
}

// 创建layer
- (void)createLayer {
    self.shapeLayer = [CAShapeLayer layer];
    // 定义贝塞尔曲线路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 如果radius设置为半径的一半,则在圆外画线,如果设置的比半径和画笔宽度的差值小,则在园内画线
    [path addArcWithCenter:self.playButton.center radius:CGRectGetWidth(self.playButton.frame) / 2 - 5 startAngle:- M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    // 设置绘图路径
    self.shapeLayer.path = path.CGPath;
    // 设置填充颜色
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    // 设置画笔颜色
    self.shapeLayer.strokeColor = [UIColor magentaColor].CGColor;
    // 设置画笔宽度
    self.shapeLayer.lineWidth = 5;
    // 设置坐标
    self.shapeLayer.frame = self.view.frame;
    
    // 添加动画
    [self addAnimation];
    
}

// 添加动画
- (void)addAnimation {
    // 设动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    // 设置动画时长
    animation.duration = 5.0;
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:1.0];

    // 将动画添加到layer上
    [self.shapeLayer addAnimation:animation forKey:@"key"];
    // 将layer添加到视图上
    [self.view.layer addSublayer:self.shapeLayer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
