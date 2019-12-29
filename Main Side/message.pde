//ゲーム終了時のメッセージを表示する関数
void message() {
  
  //時間取得
  if (state==0x07) {
    getTime();
    //ホイッスル音再生
    whistle.play();
  }
  
  //3秒間表示する
  if (((el_time-cl_time)/1000)>3)
    state++;

  //--- 文字表示 ---
  fill(#ffffff); //文字の色
  textSize(200); //文字サイズ
  textAlign(CENTER);

  //game clear
  if (result==1) {
    text("GAME CLEAR!", width/2, height/2-200);
  }
  //game over
  else if (result==2) {
    text("GAME OVER!", width/2, height/2-200);
  }
}
