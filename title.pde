//タイトル表示
void title() {
  
  //時刻取得
  if (state==0x01)
    getTime();
    
  //3秒間表示する
  if ((el_time-cl_time)>3000)
    state++;

  //--- 背景・文字 ---
  background(#00bfff); //背景の色
  image(karas, 150, height/2-250);
  fill(#ffffff); //文字の色
  textSize(200);
  rectMode(CENTER); 
  text("KARAS", width/2, height/2+100);
  textSize(30); //文字サイズ
  text("Programmed by Masashi Seki", width/2+120, 700);
}
