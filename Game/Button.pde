class Button { 
  PVector position;
  float radius;
  color col;
  String text;
  boolean visible;      //if the button is visible or not

  Button(float x, float y, float r, String txt, color c) {
    position = new PVector(x, y);
    radius = r;
    text = txt;
    col = c;
    visible = true;
  }

  void display() {
    noStroke();
    fill(col);
    ellipse(position.x, position.y, radius * 2, radius * 2);
    fill(232, 197, 144);
    float fontSize = radius * 0.38;
    textSize(fontSize);
    text(text, position.x, position.y + fontSize/3);
  }
  
  boolean isClicked(){ //if button is clicked
    if (visible) {
      return dist(position.x,position.y, mouseX, mouseY) <= radius;
    }
    else {
      return false;
    }
  }
  
}
