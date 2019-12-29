//結果画面を表示させるプログラム

void ending() {
  //時刻取得と変数初期化
  if (state==0x09) {
    getTime();
    state_cho=0;
    getData=0x01;
    //音声データ巻き戻し
    whistle.rewind();
    crow.rewind();
  }

  //スイッチ状態が更新されたら
  if (getData!=0x00) {

    switch(getData) {    

    case 0x03: //sw1=ON, sw2=OFF, sw3=OFF //choice
      state_cho++;
      //音声データ再生
      button1.play();
      button1.rewind();
      if (state_cho>1)
        state_cho=0x00;
      break;

    case 0x05: //sw1=OFF, sw2=ON, sw3=OFF //incriment
      //音声データ再生
      button3.play();
      button3.rewind();
      //音楽をフェードアウトさせる
      song.shiftGain(4, -60, 3000);
      delay(3000);

      if (state_cho == 0x00) //play
        state=0x03;
      if (state_cho == 0x01) //quit
        exit(); //プログラムを終了する
      break;

    case 0x07: //sw1=OFF, sw2=OFF, sw3=OFF
      break;
    default:
      ;
    }
  }

  //--- 背景と文字表示 ---
  background(#00bfff); //背景の色
  image(karas, 100, 100); //画像表示

  fill(#ffffff); //文字の色
  textSize(150); //文字サイズ
  textAlign(CENTER);
  text("RESULT", 1300, 300);
  rectMode(CENTER); 

  //選択された部分の色を変える

  if (state_cho==0x00) fill(#adff2f);
  else fill(#7fffd4);
  rect(1050, 900, 400, 200);  

  if (state_cho==0x01) fill(#adff2f);
  else fill(#7fffd4);
  rect(1550, 900, 400, 200);  

  //--- 文字の表示 ---
  fill(0); //文字の色
  textSize(80);
  textAlign(CENTER);
  text("Play", 1050, 920);
  text("Quit", 1550, 920);

  //--- カラスのコメント ---
  image(message0, 650, 400); //画像の表示
  if (result==1) {
    image(message1, 750, 550); //画像の表示
  } else if (result==2) {
    image(message2, 1000, 550); //画像の表示
  }

  //受信データの初期化
  getData=0x00;
}
