import ddf.minim.*;

Circle[] circles;
int diam = 50;
int num_circles = 1000;
int m = 0;
int sec = 1;
int curr_circles = 0;
float sum = 0;
boolean refractory = false;
int thresh = 300;
int score;
int lives;
boolean over;
int in_game = 0;
boolean song_set = false;
boolean in_menu = true;
boolean in_selection = false;
boolean ight_repeat = true;
boolean any_repeat = true;
boolean dreaming_repeat = true;
boolean can_select_song = false;
int main_diam = 300;
PImage bg;
PImage menu_bg;
PImage selection_bg;
PImage ight_img;
PImage any_img;
PImage dreamin_img;
PImage cursor_img;
PFont font;
int thresh_inc = 0;
int dd = 1;

Minim minim;
AudioPlayer player;

void setup() {
  // background initializations
  menu_bg = loadImage("menu_bg.jpg");
  menu_bg.resize(1361, 728);
  selection_bg = loadImage("selection_bg.jpg");
  selection_bg.resize(1361, 728);
  bg = loadImage("map2.png");
  bg.resize(1361, 728);

  ight_img = loadImage("ight_img.png");
  ight_img.resize(145, 144);
  any_img = loadImage("any_img.png");
  any_img.resize(145, 144);
  cursor_img = loadImage("circle_cursor.png");
  cursor_img.resize(20, 20);
  cursor(cursor_img);

  dreamin_img = loadImage("dreamin_img.png");
  dreamin_img.resize(145, 144);

  //////////// variable + font + music initialization ////////////

  size(1361, 728);

  frameRate = 60;
  score = 0;
  lives = 100;
  over = false;
  m = millis();
  font = createFont("Aller_Bd.ttf", 32);
  minim = new Minim(this);
  player = minim.loadFile("menu_music.mp3");
  player.play();
  generate_new_circles();
  
}

// generates new circles
void generate_new_circles() {
  circles = new Circle[num_circles];
  for (int i = 0; i < circles.length; i++) {
    circles[i] = new Circle(random(diam/2, width-(diam/2)), random(diam/2 + + height/14, height-(diam/2)), diam);
  }
}

void draw_wave() {
  //background(0);
  stroke(255);
  
  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  // note that if the file is MONO, left.get() and right.get() will return the same value
  for(int i = 0; i < player.bufferSize() - 1; i++)
  {
    float x1 = map( i, 0, player.bufferSize(), 0, width );
    float x2 = map( i+1, 0, player.bufferSize(), 0, width );
    stroke(255);
    line(x1, 50 + player.left.get(i)*50, x2, 50 + player.left.get(i+1)*50 );
    line(x1, 150 + player.right.get(i)*50, x2, 150 + player.right.get(i+1)*50 );
    
    stroke(0);
    line(x1, height - 150 + player.left.get(i)*50, x2, height - 50 + player.left.get(i+1)*50 );
    line(x1, height - 50 + player.right.get(i)*50, x2, height - 150 + player.right.get(i+1)*50 );
    
    // across entire screen
    //line(x1, 50 + player.left.get(i)*50, x2, height - 200 + player.left.get(i+1)*50 );
    //line(x1, 150 + player.right.get(i)*50, x2, height - 300 + player.right.get(i+1)*50 );
  }
}


void main_menu() {
  if (main_diam > 350) dd = -1;
  else if (main_diam < 310) dd = 1;
    
  main_diam += dd;
  background(menu_bg);
  fill(255);
  noStroke();
  circle(width/2, height/2, main_diam);
  fill(0);
  textFont(font, 70);
  text("mosu!", width/2.335, height/1.9);
  
  if (!player.isPlaying()){
    player.rewind();
    player.play();
  }
}

void info_bar() {
  fill(255, 255, 255, 30);
  noStroke();
  rect(0,0,width,height/14);
  fill(0);
  if (in_game == 4 || in_game == 3) fill(255);
  textSize(30);
  //stroke(255);
  //strokeWeight(1);
  text("Score: " + score, 10, 40);
  text("Lives: " + lives, width-150, 40);
}

void progress_bar() {
  int max = 200;
  float posx = map(player.position(), 0, player.length(), 0, max);
  stroke(255);  
  fill(255);
  rect(0,height/14, max, 10);
  fill(0,0,0,80);
  rect(0,height/14,posx, 10);
}

void init_song() {
  song_set = true;
  player.pause();
  
  if (in_game == 0) {
    player = minim.loadFile("menu_music.mp3");
    player.play();
  }
  if (in_game == 2) { // first song
    thresh = 300;
    bg = loadImage("map1.jpg");
    bg.resize(1361, 728);
    player = minim.loadFile("ight.mp3");
    player.play();
  } else if (in_game == 3) { // second song
    thresh = 300;
    bg = loadImage("map2.png");
    bg.resize(1361, 728);
    player = minim.loadFile("Any_Song.mp3");
    player.play();
  } else if (in_game == 4) { // third song
    thresh = 90;
    bg = loadImage("map3.png");
    bg.resize(1361, 728);
    player = minim.loadFile("dreaming.mp3");
    player.play();
  }
}

// loads the game selection menu
void game_selection() {
  if (!player.isPlaying()) init_song();
  
  //in_menu = false;
  in_selection = true;
  background(selection_bg);
  strokeWeight(2);
  stroke(0);
  
  // cursor in rect x
  if (mouseX > width/4 && mouseX < width/4 + width/2) {
    // cursor in 1st rect
    if (mouseY > height/5 && mouseY < height/5 + height/4.98) {
      in_game = 2;
      if (ight_repeat) init_song();
      ight_repeat = false;
      any_repeat = true;
      dreaming_repeat = true;
      
      // grays out
      fill(255, 255, 255, 99);
      rect(width/4, height/5, width/2, height/4.98);
      fill(0);
      textSize(30);
      text("Is That Ight - Jack Harlow", width/3.7, height/3);
      
      fill(255);
      rect(width/4, 2*height/5, width/2, height/5);
      fill(0);
      text("Any Song - ZICO", width/3.7, height/1.9);
      
      fill(255);
      rect(width/4, 3*height/5, width/2, height/5);
      fill(0);
      text("Am I Dreaming - Metro Boomin", width/3.7, height/1.39);
      
      tint(255, 80);
      image(ight_img, 3*width/4 - 145, height/5 + 1);
      noTint();
      image(any_img, 3*width/4 - 145, 2*height/5 + 1);
      image(dreamin_img, 3*width/4 - 145, 3*height/5 + 1);
    } 
    else if (mouseY > 2*height/5 && mouseY < 2*height/5 + height/4.98) {
      in_game = 3;
      if (any_repeat) init_song();
      ight_repeat = true;
      any_repeat = false;
      dreaming_repeat = true;
      
      fill(255);
      rect(width/4, height/5, width/2, height/4.98);
      fill(0);
      textSize(30);
      text("Is That Ight - Jack Harlow", width/3.7, height/3);
      
      fill(255, 255, 255, 99);
      rect(width/4, 2*height/5, width/2, height/5);
      fill(0);
      text("Any Song - ZICO", width/3.7, height/1.9);
      
      fill(255);
      rect(width/4, 3*height/5, width/2, height/5);
      fill(0);
      text("Am I Dreaming - Metro Boomin", width/3.7, height/1.39);
      
      image(ight_img, 3*width/4 - 145, height/5 + 1);
      tint(255, 80);
      image(any_img, 3*width/4 - 145, 2*height/5 + 1);
      noTint();
      image(dreamin_img, 3*width/4 - 145, 3*height/5 + 1);
    }
    else if (mouseY > 3*height/5 && mouseY < 3*height/5 + height/4.98) {
      in_game = 4;
      if (dreaming_repeat) init_song();
      ight_repeat = true;
      any_repeat = true;
      dreaming_repeat = false;
      
      fill(255);
      rect(width/4, height/5, width/2, height/4.98);
      fill(0);
      textSize(30);
      text("Is That Ight - Jack Harlow", width/3.7, height/3);
      
      fill(255, 255, 255);
      rect(width/4, 2*height/5, width/2, height/5);
      fill(0);
      text("Any Song - ZICO", width/3.7, height/1.9);
      
      fill(255, 255, 255, 99);
      rect(width/4, 3*height/5, width/2, height/5);
      fill(0);
      text("Am I Dreaming - Metro Boomin", width/3.7, height/1.39);
      
      noTint();
      image(ight_img, 3*width/4 - 145, height/5 + 1);
      image(any_img, 3*width/4 - 145, 2*height/5 + 1);
      tint(255, 80);
      image(dreamin_img, 3*width/4 - 145, 3*height/5 + 1);
    }
    
    else {
      noTint();

      fill(255);
      rect(width/4, height/5, width/2, height/4.98);
      fill(0);
      textSize(30);
      text("Is That Ight - Jack Harlow", width/3.7, height/3);
      image(ight_img, 3*width/4 - 145, height/5 + 1);

      
      fill(255, 255, 255);
      rect(width/4, 2*height/5, width/2, height/5);
      fill(0);
      text("Any Song - ZICO", width/3.7, height/1.9);
      image(any_img, 3*width/4 - 145, 2*height/5 + 1);

      
      fill(255, 255, 255);
      rect(width/4, 3*height/5, width/2, height/5);
      fill(0);
      text("Am I Dreaming - Metro Boomin", width/3.7, height/1.39);
      
      image(dreamin_img, 3*width/4 - 145, 3*height/5 + 1);
  }
    
  }
  
  else {
    noTint();
    fill(255);
    rect(width/4, height/5, width/2, height/4.98);
    fill(0);
    textSize(30);
    text("Is That Ight - Jack Harlow", width/3.7, height/3);
    image(ight_img, 3*width/4 - 145, height/5 + 1);
    
    fill(255, 255, 255);
    rect(width/4, 2*height/5, width/2, height/5);
    fill(0);
    text("Any Song - ZICO", width/3.7, height/1.9);
    image(any_img, 3*width/4 - 145, 2*height/5 + 1);

    fill(255, 255, 255);
    rect(width/4, 3*height/5, width/2, height/5);
    fill(0);
    text("Am I Dreaming - Metro Boomin", width/3.7, height/1.39);
    image(dreamin_img, 3*width/4 - 145, 3*height/5 + 1);
  }
  
  //tint(255, 50);
  //image(ight_img, 3*width/4 - 145, height/5);


}


// runs entire game
void draw() {
  // main menu
  if (in_game == 0) {
    main_menu();
    draw_wave();
  }
  
  // song selection
  else if (in_selection) {
    game_selection();
  }
  
  // running song
  else {
    if (!song_set) init_song();
    if (!over) run(); 
    else end_game();
    info_bar();
  }
}

// draws all the lines
void draw_lines() {
  // for every current circle
  strokeWeight(2);
  if (curr_circles > 0) {
    for (int i = 0; i < curr_circles - 1; i++) {
      // if curr + next circle displayed --> draw line
      if (circles[i].displayed == true && circles[i + 1].displayed == true) {
        stroke(255);
        line(circles[i].x, circles[i].y, circles[i+1].x, circles[i+1].y);
      }
    }
  }
}

// gameover
void end_game() {  
  over = true;
  player.pause(); // pause music
  
  // game over screen
  image(bg, 0, 0);
  filter(BLUR, 6);
  fill(0,0,0,50);
  rect(width/4, height/4, width/2, height/2);
  fill(255);
  textSize(30);
  text("Final Score: " + score, 6*width/14, height/2.4);
  if (lives < 0) lives = 0;
  text("Final Lives: " + lives, 6*width/14, height/2.0);
  text("Press R to restart", 5.84*width/14, height/1.5);
}

void keyPressed() {
  if (key == 'r') {
    reset();
    player.rewind();
    player.play();
  }
  if (key == 'm') {
    reset();
    in_selection = true;
    in_menu = false;
  }
}

void reset() {
  over = false;
  lives = 100;
  score = 0;
  curr_circles = 0;
  generate_new_circles();
}

// runs program
void run() {  
  if (!player.isPlaying() || curr_circles > 995) {
    end_game();
  }
  
  else {
    if (lives < 1) over = true;
    background(bg);
    sum = 0;
  
    // gets sound level
    for (int i = 0; i < player.bufferSize() - 1; i++) {
        sum += abs(player.mix.get(i));
        if (in_game == 4) {
          if (sum > 150 && thresh_inc == 0) {
            thresh = 150;
            thresh_inc++;
          }
          else if (sum > 230 && thresh_inc == 1) {
            thresh = 230;
            thresh_inc++;
          }
        }
    }
    
    // displays circles on screen
    for (int i = 0; i < curr_circles; i++) { 
      circles[i].display();
    }
    
    // circle if reaches certain sound level
    if (sum > thresh && curr_circles < num_circles - 1 && refractory == false) {
      curr_circles++;
      delay(100);
    }
    println(sum);
    
    draw_lines();
    progress_bar();

  }
}

void mousePressed() {
  if (in_selection) {
    if (mouseX > width/4 && mouseX < width/4 + width/2) {
    // cursor in 1st rect
      if (mouseY > height/5 && mouseY < height/5 + height/4.98) {
        in_menu = false;
        in_selection = false;
        in_game = 2;
        init_song();
      }
      else if (mouseY > 2*height/5 && mouseY < 2*height/5 + height/4.98) {
        in_menu = false;
        in_selection = false;
        in_game = 3;
        init_song();
      }
      else if (mouseY > 3*height/5 && mouseY < 3*height/5 + height/4.98) {
        in_menu = false;
        in_selection = false;
        in_game = 4;
        init_song();
      }
    }
  }
  
  // if in menu
  if (in_game == 0 && dist(width/2, height/2, mouseX, mouseY) < 300 / 2) {
    in_game = 1; // set to map selection
    in_selection = true;
    //delay(100);
  }
  
  for (int i = 0; i < circles.length; i++) {
    if (circles[i].contains(mouseX, mouseY)) {
      circles[i].clicked();
    }
  }
}

class Circle { // circle class
  float x, y; // pos
  float diam; // diam
  float shrink_diam; // diam for shrinking cirlce
  float time;
  boolean displayed;
  boolean clicked;

  Circle(float x_, float y_, float diam_) {
    x = x_;
    y = y_;
    diam = diam_;

    time = millis();
    shrink_diam = diam_ + 20;
    displayed = false;
    clicked = false;
  }
  
  // shows circle on window
  void display() { 
    if (!clicked) displayed = true;
    shrink();
 
    stroke(0);
    strokeWeight(4);
    if (clicked) { // remove
      displayed = false;
      noStroke();
      noFill();

    } else { // else white
      if (in_game == 4 || in_game == 2) { // spiderman, jack harlow
        stroke(0);
      }
      else stroke(255, 255, 255);
      //fill(255, 255, 255);
      noFill();
    }

    ellipse(x, y, diam, diam); // draws circle
  }
  
  void shrink() {
    //boolean alive = true;
    strokeWeight(2);
    if (in_game == 4) stroke(255, 0, 0); // spiderman
    else if (in_game == 3) stroke(255, 120, 0);// any song
    else stroke(0, 0, 255); // is that ight
    noFill();
    
    // player clicked
    if (clicked) { 
      if (shrink_diam == diam && displayed) score += 10;
      else if (displayed) score += 2;
      displayed = false;
      noStroke(); // turn white
    }
    
    // disappear/not clicked
    if (shrink_diam < diam - 2) {
      if (!clicked && displayed) lives -= 1;
      displayed = false;
      clicked = true;
    }
    
    // shrink outer circle
    if (shrink_diam > 40 && millis() - time > 250 && !clicked) { // shrinks every 0.25 seconds
      time = millis();
      shrink_diam -= 2;
    }

    ellipse(x, y, shrink_diam, shrink_diam);
  }

  void clicked() {
    clicked = true;
  }

  boolean contains(float x_, float y_) {
    return dist(x, y, x_, y_) < diam / 2;
  }
}
