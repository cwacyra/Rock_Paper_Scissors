import processing.video.*;
import gab.opencv.*;


float minBlobSize = 1000;
float tolerance =    5;   // how much wiggle-room is 

int playscore;
int compscore;


// allowed in matching the color?
Capture webcam;
OpenCV cv;
ArrayList<Contour> blobs;
int[]opponent;

boolean showTitleScreen = true;
boolean beginGame = false;
boolean match = false;

PImage playrock;
PImage playpaper;
PImage playscissors;
PImage opprock;
PImage opppaper;
PImage oppscissors;

void setup() {
  size(1280, 720);
  cv = new OpenCV(this, width,height);
  // start the webcam
  String[] inputs = Capture.list();
  
  opponent = new int[3]; // Create
  opponent[0] = 1;
  opponent[1] = 2;
  opponent[2] = 3;
  
  playscore = 0;
  compscore = 0;
  
  playrock = loadImage("playrock.png");
  playpaper = loadImage("playhand.png");
  playscissors = loadImage("playscissor.png");
  opprock = loadImage("opprock.png");
  opppaper = loadImage("opphand.png");
  oppscissors = loadImage("oppscissors.png");
  
 

  if (inputs.length == 0) {
    println("Couldn't detect any webcams connected!");
    exit();
  }
  webcam = new Capture(this, inputs[0]);
  webcam.start();
}

void keyPressed(){
  if(showTitleScreen){
    if(keyCode == ENTER){
      showTitleScreen = false;
      beginGame = true; 
    }
  }
  if(match == true){
    if(keyCode == ENTER){
     loop();
  }
 }
}

void draw() {
  //Title Screen loop
  if(showTitleScreen){
    background(255,255,255);
    textSize(18);
    fill(0,0,0);
    text("Press: 'ENTER' to begin the game", width/2-130, 360);
  }
 if (beginGame){
    
  if (webcam.available()) {

    // read from the webcam
    webcam.read();
    
    cv.loadImage(webcam);
    //this runs the webcam image  i think
    
    image(webcam, 0, 0);
    
    blobs = cv.findContours();
    noFill();
    stroke(255,150,0);
    strokeWeight(3);
    
    loadPixels();
    for (int i = 0; i<pixels.length; i++) {
      float r = pixels[i] >> 16 & 0xFF;
      float g = pixels[i] >> 8 & 0xFF;
      float b = pixels[i] & 0xFF;

      if (r >= 200 && r<=255 && g >= 0 && g< 120 && b >= 0 && b <=120  ) {
        pixels[i] = color(255, 255, 255);
      }
      else {
        pixels[i] = color(0, 0, 0);
      }
    }
    updatePixels();
    cv.loadImage(get());
    
    // get the blobs and draw them
    blobs = cv.findContours();
    noFill();
    stroke(255,150,0);
    strokeWeight(3);
    int numBlobs = 0;
    for (Contour blob : blobs) {
      // optional: reject blobs that are too small
      if (blob.area() < minBlobSize) {
        continue;
      }
      numBlobs += 1;
      beginShape();
      for (PVector pt : blob.getPolygonApproximation().getPoints()) {
        vertex(pt.x, pt.y);
      }
      endShape(CLOSE);
    }
    println(numBlobs); 
    
    
    
    //scenery
    background(0,0,0);
    textSize(60);
    fill(255,255,255);
    text("Player: "  + playscore, 5,60);
    text("Computer: " + compscore, width - 415,60);
       //textSize(80);
       //text("TIE", width/2-65, 360);
      //text("YOU WIN", width/2-165, 360);
       //text("YOU LOSE", width/2-195,360);
       //textSize(20);
       //text("Press 'ENTER' to begin next round", width/2 - 165, 400);

       
    
    
    //game portion //////
   
   //if throw rock
    if(numBlobs == 1){ 
       match = true;
       int rand = (int)random(opponent.length);
       println("sup" + opponent[rand]);
       image(playrock, 75, 250, 350, 350);
       
       if(opponent[rand] == 1){
         image(opprock, width-425 ,250, 350, 350);
         textSize(80);
         text("TIE", width/2-65, 360);
         textSize(20);
         text("Press 'ENTER' to begin next round", width/2 - 165, 400);
         noLoop();
         
       }
       if(opponent[rand] == 2){
         image(oppscissors, width-425 ,250, 350, 350);
         textSize(80);
         text("YOU WIN", width/2-165, 360);
         textSize(20);
         text("Press 'ENTER' to begin next round", width/2 - 165, 400);
         playscore ++;
         noLoop();
         
       }
       if(opponent[rand] == 3){
         image(opppaper, width-425 ,250, 350, 350);
          textSize(80);
          text("YOU LOSE", width/2-195,360);
          textSize(20);
          text("Press 'ENTER' to begin next round", width/2 - 165, 400);
         compscore ++;
         noLoop();
       }
    }
    
    //if throw scissors
    if(numBlobs == 3){
       match=true;
       int rand = (int)random(opponent.length);
       println("sup" + opponent[rand]);
       image(playscissors, 75, 250, 350, 350);
       
       if(opponent[rand] == 1){
         image(opprock, width-425 ,250, 350, 350);
         textSize(80);
         text("YOU LOSE", width/2-195,360);
         textSize(20);
         text("Press 'ENTER' to begin next round", width/2 - 165, 400);
         compscore ++;
         noLoop();
         
       }
       if(opponent[rand] == 2){
         image(oppscissors, width-425 ,250, 350, 350);
          textSize(80);
         text("TIE", width/2-65, 360);
         textSize(20);
         text("Press 'ENTER' to begin next round", width/2 - 165, 400);
         noLoop();
         
       }
       if(opponent[rand] == 3){
         image(opppaper, width-425 ,250, 350, 350);
          textSize(80);
         text("YOU WIN", width/2-165, 360);
         textSize(20);
         text("Press 'ENTER' to begin next round", width/2 - 165, 400);
         playscore ++;
         noLoop();
       }
    }
    if(numBlobs == 4){
       match=true;
       int rand = (int)random(opponent.length);
       println("sup" + opponent[rand]);
       image(playpaper, 75, 250, 350, 350);
       
       if(opponent[rand] == 1){
         image(opprock, width-425 ,250, 350, 350);
          textSize(80);
         text("YOU WIN", width/2-165, 360);
         textSize(20);
         text("Press 'ENTER' to begin next round", width/2 - 165, 400);
         playscore ++;
         noLoop();
         
       }
       if(opponent[rand] == 2){
         image(oppscissors, width-425 ,250, 350, 350);
         textSize(80);
         text("YOU LOSE", width/2-195,360);
         textSize(20);
         text("Press 'ENTER' to begin next round", width/2 - 165, 400);
         compscore ++;
         noLoop();
         
       }
       if(opponent[rand] == 3){
         image(opppaper, width-425 ,250, 350, 350);
         textSize(80);
         text("TIE", width/2-65, 360);
         textSize(20);
         text("Press 'ENTER' to begin next round", width/2 - 165, 400);
         noLoop();
       }
    }
  }
 }
}