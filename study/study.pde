import controlP5.*;
ControlP5 slider;

//スライダー
Slider slider_Lr;
Slider slider_s1;
Slider slider_s3;

//曲線の精度
float STEP = 2 * PI * 0.01;
//左側の渦巻き
float Ltheta = 4 * PI;
float origin_Ltheta = 4 * PI;
float min_height = 0;
int Lspiral;
float La= 1.1;
float Lb;
float Lr;
float Lrr;//直径を制御
float Latranslate;
float Lx, Ly;
float last_Lspiral;
float last_Lb;
float last_Lr;
float last_Lrr;
float origin_Lrr;
float last_Latranslate;
int draw = 1;
float maxR;
int maxR_abc = 0;

//ベジェ
int count;//ベジェの終点を定める
float bezierXl;
float bezierYl;
float bezierXr;
float bezierYr;
float s1, s3;
float origin_s1;
float origin_s3;

void setup(){
  size(800,800);
  colorMode(RGB,255);
  background(255);
  
  //コントローラを生成
  slider = new ControlP5(this);
  //Lr：直径
  slider_Lr = slider.addSlider("Lr")
   .setPosition(width/2+50,660)  //スライダーの位置
   .setSize(100,20)  //スライダーのサイズ
   .setRange(0, 30)  //最小値と最大値
   .setValue(1.5)  //初期値
   .setColorCaptionLabel(0)  //スライダーの文字の色
   ;
  //Lspiralの値を動かすスライダー
  slider.addSlider("Lspiral")
   .setPosition(10,10)  //スライダーの位置
   .setSize(100,20)  //スライダーのサイズ
   .setRange(1,2)  //最小値と最大値
   .setValue(int(random(1,3)))  //初期値
   .setColorCaptionLabel(0)  //スライダーの文字の色
   ;
  //Lbの値を動かすスライダー
  slider.addSlider("Lb")
   .setPosition(10,40)  //スライダーの位置
   .setSize(100,20)  //スライダーのサイズ
   .setRange(0,10)  //最小値と最大値
   .setValue(random(0,10))  //初期値
   .setColorCaptionLabel(0)  //スライダーの文字の色
   ;
  //Latranslateの値を動かすスライダー
  slider.addSlider("Latranslate")
   .setPosition(10,70)  //スライダーの位置
   .setSize(100,20)  //スライダーのサイズ
   .setRange(0, 0.5)  //最小値と最大値
   .setValue(random(0,0.2))  //初期値
   .setColorCaptionLabel(0)  //スライダーの文字の色
   ;
   
  //渦巻きの大きさとベジェのバランス調整
  if(int(slider.getController("Lspiral").getValue()) == 1){
    //Lrrの値を動かすスライダー
    slider.addSlider("Lrr")
     .setPosition(10,100)  //スライダーの位置
     .setSize(100,20)  //スライダーのサイズ
     .setRange(3,5.5)  //最小値と最大値
     .setValue(random(3,5.5))  //初期値
     .setColorCaptionLabel(0)  //スライダーの文字の色
     ;
    maxR= Lrr * Lr * (pow(La+0.1*Latranslate,4*PI+100*STEP)+Lb);
  }
  else if(int(slider.getController("Lspiral").getValue()) == 2){
    //Lrrの値を動かすスライダー
    slider.addSlider("Lrr")
     .setPosition(10,100)  //スライダーの位置
     .setSize(100,20)  //スライダーのサイズ
     .setRange(1,4)  //最小値と最大値
     .setValue(random(1,3.5))  //初期値
     .setColorCaptionLabel(0)  //スライダーの文字の色
     ;
    maxR= Lrr * Lr * (pow(La+0.2*Latranslate,4*PI+200*STEP)+Lb);
  }
  println(maxR);
  
  //maxRの値でベジェの位置を決める
  if(maxR > 20 && maxR < 50){
    //ベジェ
    bezierXr = 390;
    //s1の値を動かすスライダー
    slider_s1 = slider.addSlider("s1")
     .setPosition(width/2+50,600)  //スライダーの位置
     .setSize(100,20)  //スライダーのサイズ
     .setRange(0,500)  //最小値と最大値
     .setValue(247)  //初期値
     .setColorCaptionLabel(0)  //スライダーの文字の色
     ;
    //s3の値を動かすスライダー
    slider_s3 = slider.addSlider("s3")
     .setPosition(width/2+50,630)  //スライダーの位置
     .setSize(100,20)  //スライダーのサイズ
     .setRange(0,500)  //最小値と最大値
     .setValue(265)  //初期値
     .setColorCaptionLabel(0)  //スライダーの文字の色
     ;
    maxR_abc=1;
    println("小さい");
  }
  else if(maxR >= 50 && maxR < 80){
    //ベジェ
    bezierXr = 440;
    //s1の値を動かすスライダー
    slider_s1 = slider.addSlider("s1")
     .setPosition(width/2+50,600)  //スライダーの位置
     .setSize(100,20)  //スライダーのサイズ
     .setRange(0,500)  //最小値と最大値
     .setValue(0.22*maxR + 260)  //初期値
     .setColorCaptionLabel(0)  //スライダーの文字の色
     ;
    //s3の値を動かすスライダー
    slider_s3 = slider.addSlider("s3")
     .setPosition(width/2+50,630)  //スライダーの位置
     .setSize(100,20)  //スライダーのサイズ
     .setRange(0,500)  //最小値と最大値
     .setValue(320)  //初期値
     .setColorCaptionLabel(0)  //スライダーの文字の色
     ;
    maxR_abc=2;
    println("中くらい");
  }
  else if(maxR >= 80 && maxR < 130){
    //ベジェ
    bezierXr = 500;
    //s1の値を動かすスライダー
    slider_s1 = slider.addSlider("s1")
     .setPosition(width/2+50,600)  //スライダーの位置
     .setSize(100,20)  //スライダーのサイズ
     .setRange(0,500)  //最小値と最大値
     .setValue(0.28*maxR + 295)  //初期値
     .setColorCaptionLabel(0)  //スライダーの文字の色
     ;
    //s3の値を動かすスライダー
    slider_s3 = slider.addSlider("s3")
     .setPosition(width/2+50,630)  //スライダーの位置
     .setSize(100,20)  //スライダーのサイズ
     .setRange(0,500)  //最小値と最大値
     .setValue(315)  //初期値
     .setColorCaptionLabel(0)  //スライダーの文字の色
     ;
    maxR_abc=3;
    println("大きい");
  }

  //Lxの値を動かすスライダー
  slider.addSlider("Lx")
   .setPosition(680,10)  //スライダーの位置
   .setSize(100,20)  //スライダーのサイズ
   .setRange(-width/2, width/2)  //最小値と最大値
   .setValue(-200)  //初期値
   .setColorCaptionLabel(0)  //スライダーの文字の色
   ;
  //Lyの値を動かすスライダー
  slider.addSlider("Ly")
   .setPosition(680,40)  //スライダーの位置
   .setSize(100,20)  //スライダーのサイズ
   .setRange(-height/2, height/2)  //最小値と最大値
   .setValue(-42)  //初期値
   .setColorCaptionLabel(0)  //スライダーの文字の色
   ;

  last_Lspiral = int(slider.getController("Lspiral").getValue());
  last_Lb = slider.getController("Lb").getValue();
  last_Lr = 1;
  last_Lrr = slider.getController("Lrr").getValue();
  origin_Lrr = slider.getController("Lrr").getValue();
  println(origin_Lrr);
  last_Latranslate = slider.getController("Latranslate").getValue();
  origin_s1 = slider.getController("s1").getValue();
  origin_s3 = slider.getController("s3").getValue();
}