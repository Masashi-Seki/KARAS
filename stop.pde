//プログラム終了時に呼び出される関数
void stop(){
  //音楽ファイルの終了
  button1.close();
  button2.close();
  button3.close();
  song.close();
  whistle.close();
  countdown.close();
  minim.stop();
  super.stop();
}
