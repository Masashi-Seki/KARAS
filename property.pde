//ゲーム設定画面の関数
void property() {

  //時間取得
  if (state==0x03) {
    getTime();
    reset();
  }

  //スイッチ状態が変化hしたら
  if (getData!=0x00) {

    //スイッチ状態を振り分け
    switch(getData) {    

    case 0x03: //sw1=ON, sw2=OFF, sw3=OFF //choice
      state_cho++;
      //押された音再生
      button1.play();
      button1.rewind();

      if (state_cho>2)
        state_cho=0x00;
      break;

    case 0x05: //sw1=OFF, sw2=ON, sw3=OFF //incriment
      //押された音再生
      button2.play();
      button2.rewind();

      //変数更新
      if (state_cho == 0x00) //レベル
        state_lev++;
      if (state_cho == 0x01) //人数
        state_num++;
      if (state_cho == 0x02) { //ゲームPlay
        state++; //Game play!
        //押された音再生
        button3.play();
        button3.rewind();
      }

      if (state_lev>2)
        state_lev=0x00;
      if (state_num>3)
        state_num=0x00;
      break;

    case 0x07: //sw1=OFF, sw2=OFF, sw3=OFF
      break;
    default:
      ;
    }
  }

  //--- 背景・文字絵画 ---
  background(#00bfff); //背景の色
  //画像表示
  image(karas, 100, 100);

  fill(#ffffff); //文字の色
  textSize(150);
  textAlign(CENTER);
  text("PROPERTY", 1300, 300);
  rectMode(CENTER); 

  //--- 選択中の枠の色を変える ---

  if (state_cho==0x00) fill(#adff2f);
  else fill(#7fffd4);
  rect(1050, 600, 400, 300);  

  if (state_cho==0x01) fill(#adff2f);
  else fill(#7fffd4);
  rect(1550, 600, 400, 300);  

  if (state_cho==0x02) fill(#adff2f);
  else fill(#7fffd4);
  rect(1300, 900, 900, 200);

  fill(0); //文字の色
  textSize(80); //文字サイズ
  textAlign(CENTER);
  text("Level", 1050, 550);
  text("Player", 1550, 550);
  text("Play!", 1300, 920);

  textSize(110); //文字サイズ
  text(state_lev+1, 1050, 700);
  text(state_num+1, 1550, 700);

  getData=0x00; //受信データ初期化
}
