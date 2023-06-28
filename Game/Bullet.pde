class Bullet {
  PImage sprite;
  PVector position;
  float oldX, oldY, rotation, xSpeed, ySpeed, r;
  int wallCollisions;
  boolean collision;
  PImage[] passive = new PImage[10];
  PImage[] deadly = new PImage[10];
  
  Bullet(){
    position= new PVector(player.getPosition().x, player.getPosition().y);
    oldX = mouseX;
    oldY = mouseY;
    rotation = atan2(oldY - position.y, oldX - position.x) / PI * 180;  //checks angle
    xSpeed = 10;
    ySpeed = 10;
    r = 8;
    wallCollisions = 0;
    collision = false;
    sprite = loadImage("Data/cannonball.png");
    for (int i = 0; i < passive.length; i++){
      passive[i] = sprite.get(i*16, 0, 16, 16);
    }
    for (int i = 0; i < deadly.length; i++){
      deadly[i] = sprite.get(i*16, 16, 16, 16);
    }
  }
  
  void move() {
    position.x = position.x + cos(rotation/180*PI)*xSpeed;    //moving the bullet
    position.y = position.y + sin(rotation/180*PI)*ySpeed;
    if (position.x > width - left/2 - r){  //right edge bound
      xSpeed *= -1;
      wallCollisions++;
      collision = true;
    }
    else if (position.x < r + left/2){    // left edge bound
      xSpeed*=-1;
      wallCollisions++;
      collision = true;

    }
    if (position.y > height-59 - r){      //bottom edge bound
      ySpeed *= -1;
      wallCollisions++;
      collision = true;
    }
    else if (position.y < r+141){          //top edge bound
      ySpeed *= -1;
      wallCollisions++;
      collision = true;
    }
    imageMode(CENTER);
    if (collision && wallCollisions != 0) { image(deadly[(frameCount/5)%deadly.length], position.x, position.y); }    //if we have collided and wall collisions isn't 0, then switch to deadly sprite
    else { image(passive[(frameCount/5)%passive.length], position.x, position.y);; }        
    //ellipse(position.x, position.y, 2*r, 2*r);    //used for testing, essentially the hitbox of the bullet
    
  }
  
  boolean collides(Coin c){  //circle circle collision
    if (Math.pow(position.x - c.getPosition().x, 2) + Math.pow(position.y - c.getPosition().y, 2) <= Math.pow(r/2 + 50/2, 2)){
      collision = true;
      return true;
    }
    return false;
    
  }
  
  boolean collides(Player p){
    if (Math.pow(position.x - p.getPosition().x, 2) + Math.pow(position.y - p.getPosition().y, 2) <= Math.pow(r/2 + 50/2, 2)){
      return true;
    }
    return false;
  }
  
  int getCollisions(){
    return wallCollisions;
  }
  
  PVector getPosition(){
    return position;
  }
}
