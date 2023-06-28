PImage background;
int GAME_WIDTH, GAME_HEIGHT, top, left;    //gameplay region and offsets
Player player;
ArrayList<Bullet> bullets;
ArrayList<Coin> coins;
boolean[] keys = new boolean[255];    //array of keys, we only need WASD
boolean canShoot = true;    //can the player shoot
boolean damaged = false;    //is the player damaged
int canShootCount, score, screenState, health, bounces, time;    //canShootCount is the time before the player can shoot again, screenState is screen e.g menu, bounces stores the collisions of a bullet
Button hard, easy, menu;
PFont montserrat;    //font

void setup(){
  background = loadImage("Data/background.png");
  GAME_WIDTH = 1460;    //game play region
  GAME_HEIGHT = 705;
  left = width - GAME_WIDTH;    //bounds for the gameplay region
  top = height - GAME_HEIGHT;
  size(1600,900);
  background(0);
  frameRate(60);
  player = new Player();
  bullets = new ArrayList<Bullet>();
  coins = new ArrayList<Coin>();
  time = millis();
  score = 0;
  screenState = 0;
  easy = new Button(450, 400, 100, "Easy", color(32, 79, 6));      //buttons
  hard = new Button(450, 700, 100, "Hard", color(143, 37, 23));
  menu = new Button(width/2+400, 700, 100, "Play again", color(166, 106, 69));
  health=0;
  montserrat = createFont("Data/montserrat.bold.ttf", 128);
 
}

void draw(){
  if (screenState == 0) {    //main menu
    drawMenu();
  }
  else if (screenState == 1) {   //easy mode
    drawGame();
    bounces = 8;                 //less bounces making it easy
  }
  else if (screenState == 2){    //hard mode
    drawGame();
    bounces = 10;                //more bounces making cannon balls active longer
  }
  else if (screenState == 3){    //game over
    drawGameOver();
  }
}
  
void drawMenu(){                  //drawing the main menu
  background(45, 20, 8);
  fill(232, 197, 144);
  textSize(50);
  textAlign(CENTER);
  textFont(montserrat);
  text("TRIGGER (un)HAPPY", width/2, 150);
  textSize(20);
  text("Less active deadly cannon balls and a health bar", 890, 400);
  text("MORE active deadly cannon balls and ONE HIT, ONE DEATH", 900, 700);
  easy.display();
  hard.display();
  if (mousePressed && hard.isClicked()) {        //if buttons are pressed
    screenState = 2;
    health = 10;                                 //hard mode, if hit once die
    player.getPosition().set(width/2,height/2);  //set player position to middle of play area
  }
  else if (mousePressed && easy.isClicked()) {   
    screenState = 1;
    health = 100;                                //easy mode, have a health of 100, 10 shots to die
  }
}

void drawGameOver(){            //drawing the game over screen
  background(45, 20, 8);
  fill(232, 197, 144);
  textSize(50);
  textAlign(CENTER);
  textFont(montserrat);
  text("GAME OVER", width/2, 150);
  text("Score: "+score, width/2, 350);
  textSize(50);
  text("HELP: Use WASD to move, mouse to shoot. Dodge your own cannonfire", 200, 600, 800, 500);
  menu.display();  
  if (mousePressed && menu.isClicked()) {          //if clicked return to main menu reset the score
    screenState = 0;
    score = 0;
  }
}
  
void drawGame(){            //main game drawing
  clear();
  imageMode(CORNER);
  image(background,0,0);
  fill(255);
  textSize(48);
  text("Score: "+score, 180, 100);
  drawHealth(health, 1300, 50);
  float passedMillis = millis() - time;                   // calculates passed milliseconds
  if (passedMillis >= 1000 && coins.size() <= 10){        //generate a coin every second limited to 10 coins onscreen
    coins.add(new Coin());
    time=millis();
  }
  
  for (int i = bullets.size()-1; i >= 0; i--) {          
    Bullet bullet = bullets.get(i);
    bullet.move();
    if (bullet.getCollisions() == bounces) { bullets.remove(bullet); }        //if the bullet has bounced off the walls a specific amount of times, remove the active bullet
    if (bullet.collides(player) && bullet.getCollisions() != 0) {             //each collision decrease health
      bullets.remove(bullet);
      health = health - 10;
      damaged = true;
    }
  }
  
  for (int i = coins.size()-1; i >= 0; i--) {
    Coin coin = coins.get(i);
    coin.display();
    for (int j = bullets.size()-1; j >= 0; j--) {
      if (bullets.get(j).collides(coin))  {
        coins.remove(coin);
        score++;
      }
    }
  }
  
  if (health <= 0) {      //end game
    screenState = 3;
    bullets.clear();
    coins.clear();
  }
  
  pushMatrix();                     //need to store the matrix as displaying the player involves rotation operations
  updatePlayer();
  player.faceMouse();
  if (damaged) {
    player.display(true);
    if (passedMillis > 1000) {      //tint player red to show that it is damaged, then return back to normal sprite
    damaged = false;
    }                          
  }
  else {
    player.display(false);
  }
  popMatrix();
    
}

void drawHealth(int health, float x, float y) {
  float MAX_HEALTH = 100;
  float rWidth = 200;
  if (health < 25) {                                                    //changing colour
    fill(255, 0, 0);
  }  
  else if (health < 50) {
    fill(255, 200, 0);
  }
  else {
    fill(0, 255, 0);
  }
  float drawWidth = (health / MAX_HEALTH) * rWidth;    // Get fraction and multiply by width of bar
  rect(x, y, drawWidth, 50);        // Draw bar
  stroke(0);                    //outlining
  strokeWeight(2);
  noFill();
  rect(x, y, rWidth, 50);
  noStroke();
}


void keyPressed() {          //set key to be true when pressed
  keys[keyCode] = true;
}

void keyReleased() {
  keys[keyCode] = false;
}


void updatePlayer() {
  if(keys[83]) { player.move(0,6); }       //W
  if(keys[65]) { player.move(-6,0); }      //A
  if(keys[87]) { player.move(0,-6); }      //S
  if(keys[68]) { player.move(6,0); }       //D
  if (mousePressed == true) {
    if (canShoot == true) {
      bullets.add( new Bullet());
      canShoot = false;
      canShootCount = 0;          // controls the shooting speed
    }
  }
  if (canShoot == false) {          // this checks if the right amount of time has passed before canShoot can = true again
    canShootCount++;
    if (canShootCount == 15){      //if certain amount of time has passed make canShoot true. Change the number to change the duration
      canShoot = true;
    }
  }
}

  
