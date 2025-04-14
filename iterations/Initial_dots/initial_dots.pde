import java.util.Random;
ArrayList<Hit> hits;

Random random = new Random();

// Constants
float avg_lifetime = 2 * pow(10, -6);
float c = 3 * pow(10, 8);
float m_0 = 105.66 * pow(10, 6);

// Variables to store results
float x;
double y, gamma, vel, distance_travelled, energy;

void setup() {
  size(1920, 1080); // Optional: if you're using draw() for visual output
  background(0);
  hits = new ArrayList<Hit>();
  
}




void random_e() {
  // Random value between 0 and 1
  x = random.nextFloat()*5;

  // Calculate y = 10 * e^(-2.7 * x)
  y = 10*Math.pow(10,9) * Math.exp(-2.7 * x);

  // Calculate gamma
  gamma = y / m_0;

  // Prevent division by zero or invalid sqrt
  if (gamma > 1) {
    double inter = 1 - 1 / (Math.pow(gamma, 2));
    vel = c * Math.sqrt(inter);
  }

  distance_travelled = vel * avg_lifetime * gamma;
  energy = y;
}
