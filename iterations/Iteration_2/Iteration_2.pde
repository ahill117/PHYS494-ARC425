import themidibus.*;
MidiBus myBus;

ArrayList<Hit> hits;
import java.util.Random;
Random random = new Random();
float minEnergy = 0;
float maxEnergy = pow(10, 9);
int dot_num = 0;
float rand_x = 0;
float rand_y = 0;
float screen_width = 600;
float screen_height=400;

void setup() {
  size(600, 400);
  MidiBus.list();
  
  // Select correct Bus with Terrance
  myBus = new MidiBus(new java.lang.Object(), -1, 1);  //java.lang.Object fixed null pointer error on windows
  
  //fullScreen();
  background(0);
  hits = new ArrayList<Hit>();
  for (int i = 0; i < dot_num; i++) {
    hits.add(new Hit()); // Add a new random Hit object
  }
  
}

void random_dot_num() {
  dot_num = random.nextInt(10) + 1;
}

void draw() {
  background(0);  
  random_dot_num();
  for (int i = hits.size() - 1; i >= 0; i--) {
    if (!hits.get(i).isAlive()) {
      hits.remove(i);
    }
  }
  
  for (Hit h : hits) {
    h.assignColorByEnergy();
    h.display();
    h.fade();
    h.sendMidiNote();
  }
  while (hits.size() < dot_num) {
    hits.add(new Hit());
  }
  //noLoop();
  println("Hits: " + hits.size());
}


//////////////////
//Hit Definition//
//////////////////
class Hit {
  float avg_lifetime = 2 * pow(10, -6);
  float c = 3 * pow(10, 8);
  float m_0 = 105.66 * pow(10, 6);

  float x;
  double energy, gamma, vel, distance_travelled;  //physics vars
  color hitColor;   //color displayed
  float lifetime;  // Lifetime in seconds (seen)
  int birthMillis;  // Time when this hit was created
  float rand_x, rand_y;  // Position variables
  float dotSize;   //dot size
  float alpha;          // Alpha value for fading effect
  
  float gravity = 0.0005;  // Gravity effect (can adjust)
  float ySpeed = 0;     // Speed of the fall (velocity)
  float fallAccel = 0.01;  // Falling acceleration
  
   int midiNote; 

  // Constructor for the Hit class
  Hit() {
    x = random(1);  // Random x in [0, 1]
    energy = pow(10, 9) * exp(-2.7 * x);
    gamma = energy / m_0;

    if (gamma > 1) {
      double inter = 1 - 1 / Math.pow(gamma, 2);
      vel = c * sqrt((float) inter);
    } else {
      vel = 0;
    }

    distance_travelled = vel * avg_lifetime * gamma;
    // initialize midi
    midiNote = int(map((float)energy, minEnergy, maxEnergy, 60, 72));  // Map energy to MIDI note range (C4 to C5)

    // Initialize position and lifetime
    random_pos();  // Set random position
    dotSize = random(10, 30);  // set random dot size
  }

  // Assign color to hit based on its energy
  void assignColorByEnergy() {
    float normEnergy = constrain((float)(energy - minEnergy) / (maxEnergy - minEnergy), 0, 1);

    color lowColor = color(255, 0, 0);    // Red
    color midColor = color(0, 255, 0);    // Green
    color highColor = color(0, 0, 255);   // Blue

    if (normEnergy < 0.5) {
      float t = normEnergy * 2;
      hitColor = lerpColor(lowColor, midColor, t);
    } else {
      float t = (normEnergy - 0.5) * 2;
      hitColor = lerpColor(midColor, highColor, t);
    }
  }

  // Set random position and lifetime
  void random_pos() {
    rand_x = random(screen_width);  // Random position within the screen width
    rand_y = random(screen_height); // Random position within the screen height
    lifetime = random(1, 5);  // Random lifetime between 1 and 10 seconds
    birthMillis = millis();    // Record the time when the hit was created
  }
  void fade() {
    // Calculate the fade-out effect
    float timePassed = millis() - birthMillis;
    float fadeDuration = lifetime * 1000; // Fade during lifetime in milliseconds
    alpha = map(timePassed, 0, fadeDuration, 255, 0); // Fade from 255 to 0
     ySpeed += gravity;
    rand_y += ySpeed; // Update the y position with the current falling speed
    // Prevent the dot from going off the bottom of the screen
  }
  
  // note
   void sendMidiNote() {
    // Send a note-on message when the hit is alive
    if (isAlive()) {
      myBus.sendNoteOn(0, midiNote, 100);  // Channel 0, note, velocity 100
    } else {
      // Send a note-off message when the hit is no longer alive
      myBus.sendNoteOff(0, midiNote, 0);
    }
  }

  // Check if the hit is still alive
  boolean isAlive() {
    return (millis() - birthMillis) < (lifetime * 1000); // Check if the lifetime has passed
  }

  // Display the hit as a circle on the screen
  void display() {
    noStroke();
    fill(hitColor, alpha);  // Set color based on energy level
    
    ellipse(rand_x, rand_y, dotSize, dotSize);  // Draw hit as a circle at the position
  }
}
