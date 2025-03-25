/**
 * Array 2D. 
 * 
 * Demonstrates the syntax for creating a two-dimensional (2D) array.
 * Values in a 2D array are accessed through two index values.  
 * 2D arrays are useful for storing images. In this example, each dot 
 * is colored in relation to its distance from the center of the image. 
 */
import java.util.Random;
Random random = new Random();
int rand_red = 255;
int rand_green = 255;
int rand_blue = 255;
int dot_num = 2;
int rand_time = 1000;
//int

int res_width = 1920;
int res_height = 1080;

float rand_width = res_width/2;
float rand_height = res_height/2;

float[][] distances;
float maxDistance;
int spacer;

void setup() {
  fullScreen();
  maxDistance = dist(width/2, height/2, width, height);
  distances = new float[width][height];
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      float distance = dist(width/2, height/2, x, y);
      distances[x][y] = distance/maxDistance * 255;
    }
  }
}

void random_point_select() {
  //select width
  rand_width = random.nextInt(res_width);
  ///rand height
  rand_height = random.nextInt(res_height);
}

void random_color_select() {
  rand_red = random.nextInt(255);
  rand_green = random.nextInt(255);
  rand_blue = random.nextInt(255);
  
}

void random_time_select() {
  rand_time = random.nextInt(1000);
}

void random_dot_num() {
  dot_num = random.nextInt(10);
}


void draw() {
  
  background(0,0,0);
  random_dot_num();
  random_time_select();
  int i = 0;
  do {
    i += 1;
    random_color_select();
  random_point_select();
     //draw the box
  strokeWeight(20);
    //color
  stroke(rand_red,rand_green,rand_blue);
  //location
  point(rand_width,rand_height);
} while (i < dot_num);
  
 

  //noLoop();
  delay(rand_time);
  

  
  // This embedded loop skips over values in the arrays based on
  // the spacer variable, so there are more values in the array
  // than are drawn here. Change the value of the spacer variable
  // to change the density of the points
}
