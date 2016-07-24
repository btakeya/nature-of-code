void setup() {
  size(800, 600);
  background(255);

  BAR_WIDTH = ((width - (PADDING * 2)) / (float)RANGE_COUNT);

  noLoop();
}

final int SAMPLE_COUNT = 100000;
final int MAX_VALUE = 100000;
final int RANGE_COUNT = 10;
final int PADDING = 30;
float BAR_WIDTH;

import java.util.Random;

class RandomDistribution {
  int[] count;
  
  RandomDistribution() {
    count = new int[RANGE_COUNT];
  }
  
  void countRandom(float rand) {
    int index = (int)(rand / (MAX_VALUE / RANGE_COUNT));
    count[index] += 1;
  }
  
  void printCountArray() {
    for (int i = 0; i < count.length; i += 1) {
      print(count[i] + " ");
    }
    print("\n");
  }
}

int[] mkCountByProcessingRandom(RandomDistribution dist) {
  for (int iteration = 0; iteration < SAMPLE_COUNT; iteration += 1) {
    float rand = random(MAX_VALUE);
  
    dist.countRandom(rand);
  }
  
  return dist.count;
}

int[] mkCountByJavaRandom(RandomDistribution dist) {
  Random r = new Random();
  for (int iteration = 0; iteration < SAMPLE_COUNT; iteration += 1) {
    float rand = r.nextInt(MAX_VALUE);
  
    dist.countRandom(rand);
  }
  
  return dist.count;
}

int [] mkCountByGaussianRandom(RandomDistribution dist) {
  for (int iteration = 0; iteration < SAMPLE_COUNT; iteration += 1) {
    float rand = (randomGaussian() + 1) * (MAX_VALUE / 2.0);
    if (0 <= rand && rand < MAX_VALUE) {
      dist.countRandom(rand);
    }
  }
  
  return dist.count;
}

void drawGraph(int[] data) {
  //drawAxis();
  line(PADDING, PADDING, PADDING, height - PADDING);
  line(PADDING, height - PADDING, width - PADDING, height - PADDING);
 
  //drawData();
  for (int i = 0; i < data.length; i += 1) {
    float value = map(data[i], 0, MAX_VALUE / (RANGE_COUNT / 5), 0, width - PADDING * 2); 
    rect(PADDING + (i * BAR_WIDTH), (height - PADDING) - value, BAR_WIDTH, value);
    println(value + " / " + BAR_WIDTH);
  }
}

void draw() {
  RandomDistribution dist = new RandomDistribution();
  //int[] count = mkCountByProcessingRandom(dist);
  //int[] count = mkCountByJavaRandom(dist);
  int[] count = mkCountByGaussianRandom(dist);
  
  drawGraph(count);
  dist.printCountArray();
}