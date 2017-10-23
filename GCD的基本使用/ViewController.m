//
//  ViewController.m
//  GCD的基本使用
//
//  Created by YiGuo on 2017/10/23.
//  Copyright © 2017年 tbb. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self asyncMain];
}

/**
 * 同步函数 + 主队列：
 这种情况相当阻塞线程
 因为为串行执行主线程先执行了syncMain然后在执行队列中的任务
 所因形成互相等待的现象造成阻塞线程
 */
- (void)syncMain{
    NSLog(@"syncMain begin");
    // 1.获得主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 2.将任务加入队列
    dispatch_sync(queue, ^{
        NSLog(@"1-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3-----%@", [NSThread currentThread]);
    });
    NSLog(@"syncMain end");
}
/**
 * 异步函数 + 主队列：只在主线程中执行任务
 */
- (void)asyncMain{
    //获得主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //将任务加入队列
    dispatch_async(queue, ^{
        NSLog(@"1-%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2--%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3---%@", [NSThread currentThread]);
    });
}


/**
 * 同步函数 + 串行队列：不会开启新的线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务
 */
- (void)syncSerial{
    //创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("66666", DISPATCH_QUEUE_SERIAL);
    // 2.将任务加入队列
    dispatch_sync(queue, ^{
        NSLog(@"1-%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2--%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3---%@", [NSThread currentThread]);
    });
}

/**
 * 异步函数 + 串行队列：会开启新的线程，但是任务是串行的，执行完一个任务，再执行下一个任务
 */
- (void)asyncSerial{
    //创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("6666", DISPATCH_QUEUE_SERIAL);
    /**
     或者：
     dispatch_queue_t queue = dispatch_queue_create("6666", NULL);
     */
    dispatch_async(queue, ^{
        NSLog(@"1-%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2--%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3---%@", [NSThread currentThread]);
    });

}


/**
 * 同步函数 + 并发队列：不会开启新的线程(效果相当于串行)
 */
- (void)syncConcurrent{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //将任务添加入队列
    dispatch_sync(queue, ^{
        NSLog(@"1-%@", [NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"2--%@", [NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"3---%@", [NSThread currentThread]);
    });
}

/**
* 异步函数 + 并发队列：可以同时开启多条线程
*/
-(void)asyncConcurrent{
    //创建一个并发队列
//    dispatch_queue_t queue = dispatch_queue_create("666", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //将任务加入队列
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<10; i++) {
            NSLog(@"1-%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<10; i++) {
            NSLog(@"2--%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<10; i++) {
            NSLog(@"3---%@", [NSThread currentThread]);
        }
    });
    
    //执行完当前方法在执行队列中的任务，因为当前方法和其它任务不在一个线程执行。
    NSLog(@"asyncConcurrent------end");
    //ARC下不需要手动释放queue内存
    //    dispatch_release(queue);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
