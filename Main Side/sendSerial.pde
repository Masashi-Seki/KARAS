//PCからのシリアル通信データを送信する関数

void sendSerial() {

  //50フレームに1回送信する
  if (timer<50) {
    timer++;
  } else {
    //データ送信
    myPort.write(state);
    //タイマー初期化
    timer=0x00;
  }
  
}
