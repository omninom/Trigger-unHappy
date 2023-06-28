class Coin {
  PImage sprite;
  PImage [] coinSprite = new PImage[8];
  PVector position;
  float r;    //radius
  
  Coin(){
    sprite = loadImage("Data/coin.png");
    position = new PVector(random(left/2+2*r, GAME_WIDTH), random(141+2*r, height-59));    //the position of the coin is a random within the game play area
    r = 25;
    for (int i = 0; i < coinSprite.length; i++){
      coinSprite[i] = sprite.get(i*64, 0, 64, 64);
      coinSprite[i].resize(140,140);
    }
  }
  
  void display(){
    ellipseMode(CENTER);
    fill(color(255, 204, 0));
    //ellipse(position.x, position.y, 2*r, 2*r);    //used for testing, essentially the hitbox of the coin
    imageMode(CENTER);
    image(coinSprite[(frameCount/4)%coinSprite.length], position.x, position.y);
  }
  
  PVector getPosition(){
    return position;
  }
  
  
}
