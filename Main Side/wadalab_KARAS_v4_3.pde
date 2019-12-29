//シリアル通信と音楽再生のためのインポート
import processing.serial.*;
import ddf.minim.*;

//インスタンス生成
PImage karas, message0, message1, message2;
Serial myPort;
Minim minim;
AudioPlayer button1, button2, button3, song, whistle, countdown, crow;

//変数宣言
int state=0x01;
int el_time=0x00;
int cl_time=0x00;
int getData=0x00;
int timer=0x00;
int state_cho=0x00;
int state_lev=0x00;
int state_num=0x00;

int state_til;
int tilt;
int new_tilt;
int old_tilt;
float tilt_ave;
float tilt_deg;

float a=0;
float g=9.8;
float t=0;
float x=0;
float X=0;

float new_time;
float old_time;
float time;

float[] data={0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

long timeLimit;
long one_limit=15; //sec
long leave_tim;
long result;

float friction;
long start=0;
long count=0;
long L=500;

long app_time=0;
float posi_x;
float posi_y;
long karas_state;
long fall_posi;
long error;

//初期化関数
void setup() {
  fullScreen(); //フルスクリーン表示
  frameRate(30); //フレームレート設定

  //音声データのロード
  minim = new Minim(this);
  button1= minim.loadFile("button1.mp3");
  button2= minim.loadFile("button2.mp3");
  button3= minim.loadFile("button3.mp3");
  song= minim.loadFile("song.mp3");
  whistle= minim.loadFile("whistle.mp3");
  countdown = minim.loadFile("countdown.mp3");
  crow = minim.loadFile("karas.mp3");

  //画像データのロード
  karas=loadImage("karas1.png");
  message0=loadImage("message0.png");
  message1=loadImage("message1.png");
  message2=loadImage("message2.png");

  //COMポートを開ける（シリアル通信）
  myPort = new Serial(this, "COM20", 9600);

  //変数初期化
  reset();
  //PICにPICの初期化命令を送る
  myPort.write(0xFF);
}

//loop関数
void draw() {

  //プログラムが開始してからの時間を取得
  el_time=millis();
  //ゲームの状況をPICに送信（PICと同期を図る）
  sendSerial();

  //ゲームの状態により振り分ける
  switch(state) {

    //タイトル表示
  case 0x01:
    title();
    break;
  case 0x02:
    title();
    break;

    //設定画面
  case 0x03:
    property();
    break;
  case 0x04:
    property();
    break;

    //ゲーム画面
  case 0x05:
    game();
    break;
  case 0x06:
    game();
    break;

    //ゲーム終了時の表示画面
  case 0x07:
    message();
    break;
  case 0x08:
    message();
    break;

    //結果画面
  case 0x09:
    ending();
    break;
  case 0x0A:
    ending();
    break;

  default:
    break;
  }
}
