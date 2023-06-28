class Player {
  PVector position;
  PImage spriteSheet;
  PImage[] idle = new PImage[2];
  PImage [] shoot = new PImage[8];
  float r = 25;

  Player(){
    position = new PVector(width/2, height/2);            //starting position middle of game play region
    spriteSheet = loadImage("Data/spriteSheet.png");
    for (int i = 0; i < idle.length; i++){
      idle[i] = spriteSheet.get(i*67, 0, 67, 50);
    }
    for (int i = 0; i < shoot.length; i++){
      shoot[i] = spriteSheet.get(i*92, 50, 92, 50);
    }
  }
  
  void faceMouse(){
    translate(position.x, position.y);        //translate to the middle of the player
    rotate(atan2(mouseY-position.y, mouseX-position.x));    //calculate angle to the mouse position
  }

  void display(boolean damaged){
    //ellipseMode(CENTER);
    //ellipse(0,0,2*r,2*r);          //used for testing purposes, this is the hitbox of the player
    //rect(0, -10, 40, 20);
    imageMode(CENTER);
    if (damaged) { tint(255, 0, 0); }
    if (!canShoot) {
      image(shoot[(frameCount/2)%shoot.length], 20, 0);
    }
    else { image(idle[(frameCount/4)%idle.length], 7, 0); }    //7 value to fix offset
    noTint();
  }
  
  void move(float x, float y){
     position.x += x;
     position.y += y;
     if (position.x > width - left/2 - r){    //right edge bound
       position.x = width - left/2 - r;         //pop outside
     }
     else if (position.x < r + left/2) {      //left edge bound
       position.x = r + left/2;               //pop outside
     }
     if (position.y > height-59 - r){   //bottom edge bound
       position.y = height-59 - r;        //pop outside
     }
     else if(position.y < r+141){        //top edge bound
       position.y = r+141;               //pop outside
     }
  }
  
  PVector getPosition(){
    return position;
  }
  
  boolean mouseClicked() {
    return true;
  }
}
