// Added as a joke from my friend
PImage LENNY = loadImage("Lenny7.png");
int LENNY_chance = 1000; // 1 in N chance for a circle to be replaced by LENNY.png
boolean LENNY_bool = false;

final int SQUARE_SIZE = 750;


static class Utils {
	
	static String replace(String text, int index, String replacement) {
		
		String new_string = "";
		
		for (int i = 0; i < text.length; i++) {
			if (i == index) { new_string += replacement } else { new_string += text.charAt(i) }
		}
		return new_string;
	}
	
	static boolean isBetweenIn(float value, float min, float max) { return value <= max && value >= min }
	
	static boolean isBetweenEx(float value, float min, float max) { return value < max && value > min }
	
	static color bool_color(boolean bool) {
		if (bool) { return color(100, 255, 100) }
		else { return color(255, 100, 100) }
	}
	
	static String bool_showhide(boolean bool) {
		if (bool) { return "Hide" }
		else { return "Show" }
	}
	
	static String dec_precision(float value, int decimals) {
		
		float rounded = Math.round2place(value, decimals);
		String final_value = String(rounded);
		
		if (round(rounded) == rounded) { final_value += "." }
		
		for (int i = 1; i < decimals; i++) {
			if (Math.round2place(rounded, i) == rounded) { final_value += "0" }
		}
		return final_value;
	}
	
}


class Vector2 {

  float x;
  float y;

  public Vector2(float init_x, float init_y) {
    x = init_x;
    y = init_y;
  }

}


class Matrix {

  float[][] matrix;
  int rows;
  int columns;

  public Matrix(int rowSize, int columnSize) {
    matrix = new float[rowSize][columnSize];
    rows = rowSize;
    columns = columnSize;
  }


  void randomize(float min, float max) {

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        matrix[row][col] += random(min, max);
      }
    }
  }

}


static class Math {

  static final float MATH_E = 2.7182818284590452;

  static int randint(int min, int max) { return int(random(min, max)) }

	static int sign(float x) { if (x > 0) { return 1 } else if (x < 0) { return -1 } else { return 0 } }

  static float round2place(float value, int decimal) { return round(value * pow(10, decimal)) / pow(10, decimal) }

  static float tanh(float x) { return (pow(MATH_E, x) - pow(MATH_E, -x)) / (pow(MATH_E, x) + pow(MATH_E, -x)) }

  static float dist(Vector2 A, Vector2 B) { return sqrt(pow(A.x - B.x, 2) + pow(A.y - B.y, 2)) }

	static float log10(float x) { return (log(x) / log(10)) }

	static float dot_prod(Vector2 vector1, Vector2 vector2) { return (vector1.x * vector2.x) + (vector1.y * vector2.y) }

	static Vector2 vector2_add(Vector2 vector1, Vector2 vector2) { return new Vector2(vector1.x + vector2.x, vector1.y + vector2.y) }

	static Vector2 vector2_sub(Vector2 vector1, Vector2 vector2) { return new Vector2(vector1.x - vector2.x, vector1.y - vector2.y) }

  static Matrix matrix_mult(Matrix A, Matrix B) {

    if (A.columns != B.rows) {
      print("Matrix Multiplication Failed: Passed Matrix dimensions don't match");
      return new Matrix(1, 1);
    }

    Matrix Product = new Matrix(A.rows, B.columns);

    for (int i = 0; i < A.rows; i++) {
      for (int j = 0; j < B.columns; j++) {
        for (int k = 0; k < B.rows; k++) {
          Product.matrix[i][j] += A.matrix[i][k] * B.matrix[k][j];
        }
      }
    }

    return Product;
  }

  static Matrix vector_add(Matrix A, Matrix B) {

    if (A.rows != B.rows) {
      print("Vector Add failed: Vectors were not the same length");
      return new Matrix(1, 1);
    }

    Matrix final_vector = new Matrix(A.rows, 1);

    for (int i = 0; i < A.rows; i++) {
      final_vector.matrix[i][0] = A.matrix[i][0] + B.matrix[i][0];
    }

    return final_vector;
  }

  static int[] range(int max) {
    int[] final_list = new int[max];
    for (int i = 0; i < max; i++) {
      final_list[i] = i;
    }
    return final_list;
  }

}


class NeuralNet { // NETWORK CODE ----------------------------------------------------------------------------

  int[] neurons_per_layer;
  Matrix[] weights;
  Matrix[] biases;
  float[] weight_range = {-1,1};
  float[] bias_range = {-5,5};

  public NeuralNet(int[] neuron_set) {

    neurons_per_layer = neuron_set;
    weights = new Matrix[neurons_per_layer.length - 1];
    biases = new Matrix[neurons_per_layer.length];

    for (int i = 0; i < neurons_per_layer.length - 1; i++) {
      weights[i] = new Matrix(neurons_per_layer[i + 1], neurons_per_layer[i]);
      weights[i].randomize(weight_range[0], weight_range[1]);
    }

    for (int i = 0; i < neurons_per_layer.length; i++) {
      biases[i] = new Matrix(neurons_per_layer[i], 1);
      biases[i].randomize(bias_range[0], bias_range[1]);
    }
  }


  private Matrix ReLU(Matrix vector) {

    if (vector.columns != 1) {
      print("ReLU Failed: Passed Matrix had more than 1 column");
      return new Matrix(1, 1);
    }

    Matrix final_vector = new Matrix(vector.rows, 1);

    for (int i = 0; i < vector.rows; i++) {
      final_vector.matrix[i][0] = max(vector.matrix[i][0], 0);
    }

    return final_vector;
  }

  private Matrix vec_tanh(Matrix vector) {

    if (vector.columns != 1) {
      print("tanh Failed: Passed Matrix had more than 1 column");
      return new Matrix(1, 1);
    }

    Matrix final_vector = new Matrix(vector.rows, 1);

    for (int i = 0; i < vector.rows; i++) {
      final_vector.matrix[i][0] = Math.tanh(vector.matrix[i][0]);
    }

    return final_vector;
  }

	private Matrix linear_range(Matrix vector) {
		
		if (vector.columns != 1) {
      print("linear_range Failed: Passed Matrix had more than 1 column");
      return new Matrix(1, 1);
    }

    Matrix final_vector = new Matrix(vector.rows, 1);

    for (int i = 0; i < vector.rows; i++) {
      final_vector.matrix[i][0] = min(max(vector.matrix[i][0], -1), 1);
    }

    return final_vector;
	}

  Matrix run_network(Matrix inputs) {

    //print("biases total: " + biases);

    // Apply initial biases
    Matrix outputs = Math.vector_add(inputs, biases[0]);

    // Run network with ReLU activation function except last layer
    for (int layer = 1; layer < neurons_per_layer.length - 1; layer++) {
      //print("weights: " + str(weights[layer - 1].matrix[0]));
      //print("biases: " + str(biases[layer].matrix[0]));
      outputs = (Math.vector_add(Math.matrix_mult(weights[layer - 1], outputs), biases[layer]));
    }

    // Run last layer with tanh activation function
    outputs = linear_range(Math.vector_add(Math.matrix_mult(weights[neurons_per_layer.length - 2], outputs), biases[neurons_per_layer.length - 1]));

    return outputs;
  }

  private void change_random_weight() {

    int layer = Math.randint(0, weights.length);
    int row = Math.randint(0, weights[layer].rows);
    int column = Math.randint(0, weights[layer].columns);

    weights[layer].matrix[row][column] = random(weight_range[0], weight_range[1]);
  }

  private void change_random_bias() {

    int layer = Math.randint(0, biases.length);
    int row = Math.randint(0, biases[layer].rows);

    biases[layer].matrix[row][0] = random(bias_range[0], bias_range[1]);
  }

  void mutate(int loops, float bias_ratio) {

    for (int i = 0; i < loops; i++) {
      change_random_weight();
    }

    for (int i = 0; i < loops * bias_ratio; i++) {
      change_random_bias();
    }
  }

	Matrix[] copy_weights() {
	
		Matrix[] new_weights = new Matrix[weights.length];
		
		for (int layer = 0; layer < weights.length; layer++) {
			new_weights[layer] = new Matrix(weights[layer].rows, weights[layer].columns);
			
			for (int row = 0; row < weights[layer].rows; row++) {	
				for (int col = 0; col < weights[layer].columns; col++) {
					
					new_weights[layer].matrix[row][col] = weights[layer].matrix[row][col];
				}
			}
		}
		
		return new_weights;
	}

	Matrix[] copy_biases() {
		
		Matrix[] new_biases = new Matrix[biases.length];
		
		for (int layer = 0; layer < biases.length; layer++) {
			new_biases[layer] = new Matrix(biases[layer].rows, 1);
			
			for (int row = 0; row < biases[layer].rows; row++) {	
				new_biases[layer].matrix[row][0] = biases[layer].matrix[row][0];
			}
		}
		
		return new_biases;
	}

}


final int[] neurons_for_robots = {4,6,6,2};
final float max_accel = 0.1;

class Robot { // ROBOT CODE ----------------------------------------------------------------------------

  float radius;
  color robot_color;
  int id;
	String name = "";
	boolean visible = true;
	boolean spectating = true;

  Vector2 position;
  Vector2 velocity = new Vector2(0, 0);
  Vector2 acceleration = new Vector2(0, 0);

  NeuralNet neural = new NeuralNet(neurons_for_robots);

	boolean LENNY_BOOL = false; // Added as a joke from my friend, 

	private String[] consonants = {"b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","z","ch","sh","th"};
	private String[] vowels = {"a","e","i","o","u","y","ee","oo"};

  public Robot(float size, color init_color, int label, float x, float y) {
    radius = size;
    robot_color = init_color;
    position = new Vector2(x, y);
    id = label;
		for (int i = 0; i < 3; i++) { name += consonants[Math.randint(0, consonants.length)] + vowels[Math.randint(0, vowels.length)] }
		
		if (LENNY_bool) {
			if (Math.randint(0, LENNY_chance) == LENNY_chance - 1) { LENNY_BOOL = true }
		}
  }


  void show() {
		if (visible) {
			if (spectating) { fill(robot_color) }
			else { fill(robot_color, 0) }
			ellipse(position.x + 250, position.y, radius * 2, radius * 2);
			
			if (spectating) {
				fill(255);
				textAlign(CENTER, CENTER);
				textSize(20);
				text(id, position.x + 250, position.y);
			}
			
			if (LENNY_BOOL) {
				imageMode(CENTER);
				image(LENNY, position.x + 250, position.y, radius * 3, radius * 3);
			}
		}
  }

  private void update_position() {
    position.x += velocity.x;
    position.y += velocity.y;

    position.x = constrain(position.x, radius, SQUARE_SIZE - radius);
    position.y = constrain(position.y, radius, SQUARE_SIZE - radius);
  }

  private void update_velocity() {
    velocity.x += acceleration.x;
    velocity.y += acceleration.y;
    
    if (position.x == radius) {
      velocity.x = constrain(velocity.x, 0, abs(velocity.x));
    }
    if (position.x == SQUARE_SIZE - radius) {
      velocity.x = constrain(velocity.x, -abs(velocity.x), 0);
    }
    if (position.y == radius) {
      velocity.y = constrain(velocity.y, 0, abs(velocity.y));
    }
    if (position.y == SQUARE_SIZE - radius) {
      velocity.y = constrain(velocity.y, -abs(velocity.y), 0);
    }
  }

  private void update_acceleration(Vector2 goal_position) {
    Matrix inputs = new Matrix(4, 1);
    inputs.matrix[0][0] = velocity.x;
    inputs.matrix[1][0] = velocity.y;
		inputs.matrix[2][0] = goal_position.x - position.x;
		inputs.matrix[3][0] = goal_position.y - position.y;

    Matrix outputs = neural.run_network(inputs);

    acceleration.x = outputs.matrix[0][0] * max_accel;
    acceleration.y = outputs.matrix[1][0] * max_accel;
  }

  void physics_update(Vector2 goal_position) {
    update_acceleration(goal_position);
    update_velocity();
    update_position();
  }

}


class Goal {
  
  float radius;
  color goal_color;
  Vector2 position;
  
  public Goal(float size, color init_color, float x, float y) {
    radius = size;
    goal_color = init_color;
    position = new Vector2(x, y);
  }
  
  
  void show() {
    fill(goal_color);
    ellipse(position.x + 250, position.y, radius * 2, radius * 2);
  }
  
}


final color robot_color = color(150,150,150);
final float robot_radius = 20;
final color goal_color = color(255,255,30);
final float goal_radius = 50;

class Simulation { // SIMULATION CODE ----------------------------------------------------------------------------

  Robot[] population;
  int size;
  Vector2 spawn_center;
  Goal goal = new Goal(goal_radius, goal_color, -1000, -1000);

  final float[] fitness_weights = {1};
  float[] scores;
	int[] sorted_population;

  int arrange_num_row = 10;
  int arrange_radius = 30;

	int mutation_rate = 1;
	float ratio = 1;

	Robot top_robot;
	Robot median_robot;
	float top_score;
	float median_score;
	float best_score = -999;
	float best_median = -999;
	boolean new_best_score = false;
	boolean new_best_median = false;

	Robot[] priority_robots = new Robot[0];

  public Simulation(int start_robot_num, int start_x, int start_y) {

    size = start_robot_num;
    scores = new float[size];
    spawn_center = new Vector2(start_x, start_y);

    population = new Robot[size];
    for (int i = 0; i < size; i++) {
      population[i] = new Robot(robot_radius, robot_color, i + 1, start_x, start_y);
    }
  }


  void show_all() {
		goal.show();
    for (Robot robot: population) { robot.show() }
		for (Robot robot: priority_robots) { robot.show() }
  }

  void update_robots() {
    for (Robot robot: population) {
      robot.physics_update(goal.position);
    }
  }

	private int interval;
	private int arrangeX;
	private int arrangeY;

	void arrange_robots(int[] robot_id_list) {
    for (int i = 0; i < size; i++) {
      population[i].radius = arrange_radius;
      int interval = (SQUARE_SIZE - 100) / (arrange_num_row - 1);
      int arrangeX = (i % 10) * interval + 50;
      int arrangeY = int(i / 10) * interval + 50;
      
      population[robot_id_list[i]].position = new Vector2(arrangeX, arrangeY);
    }
  }

	void arrange_robots_byscore() { arrange_robots(sorted_population) }

	void arrange_robots_byid() { arrange_robots(Math.range(size)) }

	Robot sorted_robot(int ranking) { return population[sorted_population[ranking]] }

	void add_priority_robot(Robot[] robots) {
		for (int i = 0; i < robots.length; i++) { priority_robots = append(priority_robots, robots[i]) }
	}

	void clear_priority() { priority_robots = {} }

	float[][] score_id;

	void sort_robots() {
    score_id = new float[scores.length][2];
    
    for (int i = 0; i < scores.length; i++) {
      score_id[i][0] = scores[i];
      score_id[i][1] = i;
    }

    // From Internet
    int j, temp;
    boolean swapped;
    for (int i = 0; i < score_id.length - 1; i++) {
        swapped = false;
        for (j = 0; j < score_id.length - i - 1; j++) {
            if (score_id[j + 1][0] > score_id[j][0]) {

                // Swap
                temp = score_id[j];
                score_id[j] = score_id[j + 1];
                score_id[j + 1] = temp;
                swapped = true;
            }
        }

        // If no two elements were
        // swapped by inner loop, then break
        if (swapped == false)
            break;
    }

    int[] final_list = new int[score_id.length];

    for (int i = 0; i < score_id.length; i++) {
      final_list[i] = score_id[i][1];
    }

		sorted_population = final_list;
		
		top_robot = sorted_robot(0);
		median_robot = sorted_robot(int((size / 2) - 1));
		top_score = scores[top_robot.id - 1];
		median_score = scores[median_robot.id - 1];
		if (top_score > best_score) {
			best_score = top_score;
			new_best_score = true;
		} else { new_best_score = false }
		if (median_score > best_median) {
			best_median = median_score;
			new_best_median = true;
		} else { new_best_median = false }
		
  }

	void color_code_robots() {
		sorted_robot(0).robot_color = color(205, 165, 0);
		sorted_robot(1).robot_color = color(200, 200, 200);
		sorted_robot(2).robot_color = color(155, 77, 0);
		median_robot.robot_color = color(150, 50, 50);
		
		priority_robots = append(priority_robots, median_robot);
		priority_robots = append(priority_robots, sorted_robot(2));
		priority_robots = append(priority_robots, sorted_robot(1));
		priority_robots = append(priority_robots, sorted_robot(0));
	}

  void kill_robots(float percent_killed) {
		for (int i = 0; i < (size * percent_killed) / 100; i++) {
			population[sorted_population[size - 1 - i]].visible = false;
		}
	}

  void mutate_robots(float percent_killed) {
		for (int i = 0; i < (size * percent_killed) / 100; i++) {
			
			Matrix[] deceased = population[sorted_population[size - 1 - i]];
			Matrix[] survivor = population[sorted_population[i]];
			
			deceased.neural.weights = survivor.neural.copy_weights();
			deceased.neural.biases = survivor.neural.copy_biases();
			deceased.neural.mutate(mutation_rate, ratio);
			deceased.visible = true;
		}
	}

  void randomize_goal() {
    
    float pos_margin = goal_radius + robot_radius + 50;
    float neg_margin = SQUARE_SIZE - pos_margin;
    
    Vector2 P1 = new Vector2(pos_margin, pos_margin);
    Vector2 P2 = new Vector2(neg_margin, pos_margin);
    Vector2 P3 = new Vector2(neg_margin, neg_margin);
    Vector2 P4 = new Vector2(pos_margin, neg_margin);
    
    float random_value = random(0,4);
    
    if (random_value < 1) {
      goal.position = new Vector2(lerp(P1.x, P2.x, random_value), lerp(P1.y, P2.y, random_value));
    } else if (random_value < 2) {
      goal.position = new Vector2(lerp(P2.x, P3.x, random_value - 1), lerp(P2.y, P3.y, random_value - 1));
    } else if (random_value < 3) {
      goal.position = new Vector2(lerp(P3.x, P4.x, random_value - 2), lerp(P3.y, P4.y, random_value - 2));
    } else { // if (random_value < 4)
      goal.position = new Vector2(lerp(P4.x, P1.x, random_value - 3), lerp(P4.y, P1.y, random_value - 3));
    }
  }

// FITNESS FUNCTION
// Triple Whammy function
// Distance_avg
//  - Add up distance at every time step (integrate) and divide by time
//    - Incentivizes speed
//    - Rewards staying near goal
//    - Rewards correct direction
//
// AND it subtracts points for movement away from the goal

	private float final_dist;
	private float max_dist;

  void fitness_func(float max_time) {
    for (int i = 0; i < size; i++) {
			final_dist = Math.dist(population[i].position, goal.position);
			max_dist = Math.dist(spawn_center, goal.position);
			
			scores[i] += (pow(1 - (final_dist / max_dist), 3) / (max_time * 60)) * fitness_weights[0];
    }
  }

  void end_fitness_func(float max_time) {
    for (int i = 0; i < size; i++) {
			// Put Score Calculations at the end of the simulation here
		}
  }

  void reset_scores() {
    scores = new float[size];
  }

  void reset_robots() {
    for (Robot robot: population) {
			robot.position = new Vector2(spawn_center.x, spawn_center.y);
			robot.velocity = new Vector2(0,0);
			robot.acceleration = new Vector2(0,0);
      robot.radius = robot_radius;
			robot.robot_color = robot_color;
    }
  }

  void reset_goal() { goal.position = new Vector2(-1000, -1000) }

}


ArrayList<UI> PRIORITY_UI = new ArrayList<UI>();

class UI {
	
	Vector2 position;
  float width;
  float height;
	boolean visible = true;
	color fill_color = color(100);
	color text_color = color(255);
	float text_size = 20;
	PFont text_font = sansserif;

	int alignH = LEFT;
	int alignV = TOP;
	Vector2 position_shift = new Vector2(0,0);
	Vector2 render_position;

	boolean priority = false;

	public UI(float x, float y, float width_0, float height_0) {
		position = new Vector2(x,y);
		render_position = new Vector2(x,y);
    width = width_0;
    height = height_0;
	}


	void set_align(int alignmentH , int alignmentV) {
		if (alignmentH == LEFT) { position_shift.x = 0 }
		else if (alignmentH == CENTER) { position_shift.x = -width / 2 }
		else if (alignmentH == RIGHT) { position_shift.x = -width }
		
		if (alignmentV == TOP) { position_shift.y = 0 }
		else if (alignmentV == CENTER) { position_shift.y = -height / 2 }
		else if (alignmentV == BOTTOM) { position_shift.y = -height }
		
		render_position.x = position.x + position_shift.x;
		render_position.y = position.y + position_shift.y;
	}

	void set_position(float x, float y) {
		position = new Vector2(x,y);
		render_position.x = position.x + position_shift.x;
		render_position.y = position.y + position_shift.y;
	}

	void set_priority(boolean value) {
		priority = value;
		PRIORITY_UI.add(this);
	}

}


ArrayList<Button> BUTTONS = new ArrayList<Button>();

class Button extends UI {

  String label;
  
  boolean disabled = false;
  private int color_shift = 0;
  float cooldown = 0.125;
  private int frame_counter = 0;

	boolean toggle_var = false;
	boolean toggled = false;

  public Button(float x, float y, float width_0, float height_0, String text) {
		super(x, y, width_0, height_0);
    label = text;
    
    BUTTONS.add(this);
  }

  void show() {
		if (visible) {
			if (disabled) { color_shift = -50 } else { color_shift = 0 }
			if (frame_counter > 0) { frame_counter-- }

			fill(red(fill_color) + color_shift, green(fill_color) + color_shift, blue(fill_color) + color_shift);
			rect(render_position.x, render_position.y, width, height);
			fill(red(text_color) + color_shift, green(text_color) + color_shift, blue(text_color) + color_shift);
			textAlign(CENTER, CENTER);
			textSize(text_size);
			text(label, render_position.x + width / 2, render_position.y + height / 2);

			if (frame_counter == 1) { disabled = false }
		}
	}


	boolean mouseHovering() {
		return Utils.isBetweenIn(mouseX, render_position.x, render_position.x + width) && Utils.isBetweenIn(mouseY, render_position.y, render_position.y + height) && !disabled && visible;
	}

  void press() {
    if (!disabled && visible) {
      disabled = true;
      frame_counter = int(cooldown * frameRate) + 1;
    }
  }

	void flip_toggle() { if (toggle_var) { toggled = !toggled } }

}


ArrayList<TextInput> TEXTINPUTS = new ArrayList<TextInput>();

class TextInput extends UI {
	
	String default_value = "...";
	color default_text_color = color(200);
	String value = "";
	boolean num_only = false;
  
  boolean disabled = false;
  private int color_shift = 0;

	boolean typing = false;

	public TextInput(float x, float y, float width_0, float height_0, String text) {
			super(x, y, width_0, height_0);
			default_value = text;

			TEXTINPUTS.add(this);
	}


	void show() {
		if (visible) {
			if (disabled) { color_shift = -50 } else if (typing) { color_shift = 25 } else { color_shift = 0 }

			fill(red(fill_color) + color_shift, green(fill_color) + color_shift, blue(fill_color) + color_shift);
			rect(render_position.x, render_position.y, width, height);
			textAlign(CENTER, CENTER);
			textSize(text_size);
			
			if (value != "") {
				fill(red(text_color) + color_shift, green(text_color) + color_shift, blue(text_color) + color_shift);
				text(value, render_position.x + width / 2, render_position.y + height / 2);
			} else {
				fill(red(default_text_color) + color_shift, green(default_text_color) + color_shift, blue(default_text_color) + color_shift);
				textFont(monospace);
				text(default_value, render_position.x + width / 2, render_position.y + height / 2);
				textFont(sansserif);
			}
			
		}
	}

	private void filter_num() {

		String new_value = "";

		for (int letter = 0; letter < value.length; letter++) {
			for (int num = 0; num < 10; num++) {
				if (value.charAt(letter) == String(num)) {
					new_value += String(num);
				}
			}
		}

		value = new_value;
	}

	private boolean betweenX;
	private boolean betweenY;

	void press() {
		betweenX = (mouseX >= render_position.x) && (mouseX <= render_position.x + width);
		betweenY = (mouseY >= render_position.y) && (mouseY <= render_position.y + height);
		
		if (!betweenX || !betweenY && !disabled && visible) {
			if (num_only) { filter_num() }
			typing = false;
		} else if (betweenX && betweenY && !disabled && visible) {
			typing = true;
			value = "";
		}
	}

}


ArrayList<Graph> GRAPHS = new ArrayList<Graph>();

class Graph extends UI {
	
	String x_label = "";
	String y_label = "";
	
	color grid_color = color(255, 100);
	color axis_color = color(255);
	color[] line_colors;
	float[] line_weights;
	boolean[] line_visibles;
	boolean dynamicX = true;
	boolean dynamicY = false;
	float[] x_range = {0, 1};
	float[] y_range = {-1, 1};
	int lines_per_unitX = 10;
	int lines_per_unitY = 10;
	int axis_nums_decimals = 3;

	float[][] values;

	boolean show_markersX = true;
	private float[] markers_X = new float[0];
	private color[] markersX_colors = new color[0];
	private String[] markersX_labels = new String[0];
	private boolean[] markersX_top_align = new boolean[0];
	private boolean[] markersX_lines = new boolean[0];
	private boolean[] markersX_visibles = new boolean[0];

	boolean show_markersY = true;
	private float[] markers_Y = new float[0];
	private color[] markersY_colors = new color[0];
	private String[] markersY_labels = new String[0];
	private boolean[] markersY_left_align = new boolean[0];
	private boolean[] markersY_lines = new boolean[0];
	private boolean[] markersY_visibles = new boolean[0];

	private float zero_height;
	private float x_degree = ceil(Math.log10(max(abs(x_range[0]), abs(x_range[1]))));
	private float y_degree = ceil(Math.log10(max(abs(y_range[0]), abs(y_range[1]))));

	public Graph(float x, float y, float width_0, float height_0, String x_name, String y_name, int lines) {
		super(x, y, width_0, height_0);
		x_label = x_name;
		for (int i = 0; i < y_name.length; i++) { if (i != y_name.length - 1) { y_label += y_name.charAt(i) + "\n" } else { y_label += y_name.charAt(i) } }
		
		values = new float[lines][1];
		line_colors = new color[lines];
		line_weights = new float[lines];
		line_visibles = new boolean[lines];
		
		for (int i = 0; i < lines; i++) {
			values[i][0] = 0;
			line_colors[i] = color(255);
			line_weights[i] = 5;
			line_visibles[i] = true;
		}
		
		if (y_range[0] <= 0 && y_range[1] >= 0) { zero_height = map2graphY(0) }
		else if (y_range[0] > 0) { zero_height = render_position.y + height }
		else if (y_range[1] < 0) { zero_height = render_position.y }
		
		GRAPHS.add(this);
	}


	private float map2graphX(float n) { return map(n, x_range[0], x_range[1], render_position.x, render_position.x + width) }

	private float map2graphY(float n) { return map(n, y_range[0], y_range[1], render_position.y + height, render_position.y) }

	void show() {
		
		if (visible) {
			
			// Background
			fill(fill_color);
			stroke(grid_color);
			rect(render_position.x, render_position.y, width, height);
			stroke(0);

			// X-Axis
			stroke(axis_color);
			line(render_position.x, render_position.y, render_position.x, render_position.y + height);
			
			// Y-Axis
			line(render_position.x, zero_height, render_position.x + width, zero_height);
			stroke(0);
			
			// Main Axis Numbers
			fill(text_color);
			textSize(text_size);
			textAlign(RIGHT, CENTER);
			if (y_range[0] <= 0 && y_range[1] >= 0) { text("0", render_position.x - 5, zero_height) }
			text(Math.round2place(y_range[0], axis_nums_decimals), render_position.x - 5, render_position.y + height);
			text(Math.round2place(y_range[1], axis_nums_decimals), render_position.x - 5, render_position.y);
			
			textAlign(CENTER, TOP);
			text(Math.round2place(x_range[0], axis_nums_decimals), render_position.x, render_position.y + height + 3);
			text(Math.round2place(x_range[1], axis_nums_decimals), render_position.x + width, render_position.y + height + 3);
			
			// Axis Labels
			textAlign(CENTER, TOP);
			textSize(text_size);
			text(x_label, render_position.x + (width / 2), render_position.y + height + text_size);
			textAlign(CENTER, CENTER);
			textLeading(15);
			text(y_label, render_position.x - 30, render_position.y + (height / 2));
			
			// Gridlines
			stroke(grid_color);
			for (int i = (10 / lines_per_unitX) * pow(10, x_degree - 1); i < x_range[1]; i += (10 / lines_per_unitX) * pow(10, x_degree - 1)) { line(map2graphX(i), render_position.y, map2graphX(i), render_position.y + height) }
			for (int i = (10 / lines_per_unitY) * pow(10, y_degree - 1); i > y_range[0]; i -= (10 / lines_per_unitY) * pow(10, y_degree - 1)) { line(render_position.x, map2graphY(i), render_position.x + width, map2graphY(i)) }
			for (int i = (10 / lines_per_unitY) * pow(10, y_degree - 1); i < y_range[1]; i += (10 / lines_per_unitY) * pow(10, y_degree - 1)) { line(render_position.x, map2graphY(i), render_position.x + width, map2graphY(i)) }
			stroke(0);
			
			// Lines
			for (int i = 0; i < values.length; i++) {
				if (line_visibles[i]) {
					stroke(line_colors[i]);
					strokeWeight(line_weights[i]);
					for (int j = 0; j < values[i].length - 1; j++) {
						line(map2graphX(j), map2graphY(values[i][j]), map2graphX(j + 1), map2graphY(values[i][j + 1]));
					}
				}
			}
			stroke(0);
			strokeWeight(1);
			
			// X Markers
			if (show_markersX) {
				textSize(text_size);
				for (int i = 0; i < markers_X.length; i++) {
					if (markersX_visibles[i]) {
						if (markersX_lines[i]) {
							stroke(markersX_colors[i]);
							line(map2graphX(markers_X[i]), render_position.y, map2graphX(markers_X[i]), render_position.y + height);
						}
						stroke(0);
						fill(markersX_colors[i]);
						if (markersX_top_align[i]) {
							textAlign(CENTER, BOTTOM);
							text(markersX_labels[i], map2graphX(markers_X[i]), render_position.y);
						} else {
							textAlign(CENTER, TOP);
							text(markersX_labels[i], map2graphX(markers_X[i]), render_position.y + height);
						}
					}
				}
			}
			
			// Y Markers
			if (show_markersY) {
				textSize(text_size);
				for (int i = 0; i < markers_Y.length; i++) {
					if (markersY_visibles[i]) {
						if (markersY_lines[i]) {
							stroke(markersY_colors[i]);
							line(render_position.x, map2graphY(markers_Y[i]), render_position.x + width, map2graphY(markers_Y[i]));
						}
						stroke(0);
						fill(markersY_colors[i]);
						if (markersY_left_align[i]) {
							textAlign(RIGHT, CENTER);
							text(markersY_labels[i], render_position.x, map2graphY(markers_Y[i]));
						} else {
							textAlign(LEFT, CENTER);
							text(markersY_labels[i], render_position.x + width, map2graphY(markers_Y[i]));
						}
					}
				}
			}
			
		}
	}

	void add_value(float value, int line) {
		
		values[line] = append(values[line], value);
		
		for (float[] list: values) {
			if (dynamicX && list.length - 1 > x_range[1]) { x_range[1] = list.length - 1 }
			if (dynamicY && max(list) > y_range[1]) { y_range[1] = max(list) }
			if (dynamicY && min(list) < y_range[0]) { y_range[0] = min(list) }
		}

		if (y_range[0] <= 0 && y_range[1] >= 0) { zero_height = map2graphY(0) }
		else if (y_range[0] > 0) { zero_height = render_position.y + height }
		else if (y_range[1] < 0) { zero_height = render_position.y }
		
	}

	void add_markerX(float x, color line_color, String label, boolean top_align, boolean line) {
		markers_X = append(markers_X, x);
		markersX_colors = append(markersX_colors, line_color);
		markersX_labels = append(markersX_labels, label);
		markersX_top_align = append(markersX_top_align, top_align);
		markersX_lines = append(markersX_lines, line);
		markersX_visibles = append(markersX_visibles, true);
	}

	void add_markerY(float y, color line_color, String label, boolean left_align, boolean line) {
		markers_Y = append(markers_Y, y);
		markersY_colors = append(markersY_colors, line_color);
		markersY_labels = append(markersY_labels, label);
		markersY_left_align = append(markersY_left_align, left_align);
		markersY_lines = append(markersY_lines, line);
		markersY_visibles = append(markersY_visibles, true);
	}

	void clear_markersX() {
		markers_X = {};
		markersX_colors = {};
		markersX_labels = {};
		markersX_top_align = {};
		markersX_lines = {};
		markersX_visibles = {};
	}

	void clear_markersY() {
		markers_Y = {};
		markersY_colors = {};
		markersY_labels = {};
		markersY_left_align = {};
		markersY_lines = {};
		markersY_visibles = {};
	}

	void set_y_range(float[] range) {
		y_range = range;
		if (y_range[0] <= 0 && y_range[1] >= 0) { zero_height = map2graphY(0) }
		else if (y_range[0] > 0) { zero_height = render_position.y + height }
		else if (y_range[1] < 0) { zero_height = render_position.y }
	}
	
}


float text_box_scalar = 1.1;

ArrayList<TextBox> TEXTBOXES = new ArrayList<TextBox>();

class TextBox extends UI {
	
	String text_value = "";
	float text_margin = 10;

	boolean background = true;
	boolean text_wrap = true;
	boolean fixed_height = false;
	
	public TextBox(float x, float y, float width_0, String text) {
		super(x, y, width_0, 0);
		
		String[] words = split(text, " ");
		String line = "";
		float box_height = (text_size * text_box_scalar) + (text_margin * 2);

		textSize(text_size);
		for (String word: words) {
			if (word == "\n") {
				text_value += line + "\n";
				line = "";
				box_height += text_size * text_box_scalar;
			} else if (textWidth(line + word) > width - (2 * text_margin)) {
				text_value += line + "\n";
				line = word + " ";
				box_height += text_size * text_box_scalar;
			} else {
				line += word + " ";
			}
		}
		text_value += line;
		text_value = trim(text_value);
		height = box_height;

		textSize(20);
		
		TEXTBOXES.add(this);
	}


	String[] words;
	float box_height;
	String line;

	void wrap(float new_text_size) {
		words = split(str(text_value), " ");
		text_value = "";
		line = "";
		box_height = (new_text_size * text_box_scalar) + (text_margin * 2);

		textSize(new_text_size);
		for (String word: words) {
			if (word == "\n") {
				text_value += line + "\n";
				line = "";
				box_height += new_text_size * text_box_scalar;
			} else if (textWidth(line + word) > width - (2 * text_margin)) {
				text_value += line + "\n";
				line = word + " ";
				box_height += new_text_size * text_box_scalar;
			} else {
				line += word + " ";
			}
		}
		text_value += line;
		text_value = trim(text_value);
		if (!fixed_height) { height = box_height }

		textSize(20);
	}
	
	void show() {
		if (visible) {
			if (background) {
				fill(fill_color);
				rect(render_position.x, render_position.y, width, height);
			}
			fill(text_color);
			textAlign(CENTER, CENTER);
			textFont(text_font);
			textSize(text_size);
			text(text_value, render_position.x + width / 2, render_position.y + height / 2);
			textFont(sansserif);
		}
	}

	void set_text(String new_text, float size) {
		text_size = size;
		text_value = new_text;
		if (text_wrap) { wrap(text_size) }
	}

	void set_text_size(float size) {
		text_size = size;
		if (text_wrap) { wrap(text_size) }
	}

	void set_fixed_height(float new_height) {
		fixed_height = true;
		height = new_height;
	}

	void set_dynamic_height() {
		fixed_height = false;
		wrap(text_size);
	}
	
}


ArrayList<HelpButton> HELPBUTTONS = new ArrayList<HelpButton>();

class HelpButton extends Button {
	
	TextBox help_text;
	boolean top_align = false;
	boolean right_align = false;
	
	public HelpButton(float x, float y, float width_0, float height_0, float help_width, String text) {
		super(x, y, width_0, height_0, "?");
		help_text = new TextBox(0, 0, help_width, text);
		help_text.visible = false;
		
		fill_color = color(100, 100, 150);
		
		HELPBUTTONS.add(this);
	}
	
	
	void show_help() {
		if (mouseHovering()) {

			help_text.visible = true;
			if (right_align) { help_text.render_position.x = mouseX - help_text.width } else { help_text.render_position.x = mouseX }
			if (top_align) { help_text.render_position.y = mouseY } else { help_text.render_position.y = mouseY - help_text.height }

		}	else { help_text.visible = false }
	}
	
}


class UIGroup {
	
	boolean visible;
	Button[] button_group = new Button[0];
	TextInput[] input_group = new TextInput[0];
	Graph[] graph_group = new Graph[0];
	TextBox[] text_box_group = new TextBox[0];
	
	public UIGroup(boolean visible_start) {
		visible = visible_start;
	}
	
	
	void addButton(Button[] buttons) { // LATER: Optimize these methods with the concat() function
		for (Button button: buttons) {
			button_group = append(button_group, button);
			button.visible = visible;
		}
	}

	void addInput(TextInput[] inputs) {
		for (TextInput input: inputs) {
			input_group = append(input_group, input);
			input.visible = visible;
		}
	}

	void addGraph(Graph[] graphs) {
		for (Graph graph: graphs) {
			graph_group = append(graph_group, graph);
			graph.visible = visible;
		}
	}

	void addTextBox(TextBox[] text_boxes) {
		for (TextBox text_box: text_boxes) {
			text_box_group = append(text_box_group, text_box);
			text_box.visible = visible;
		}
	}

	void set_visible(boolean value) {
		visible = value;
		if (button_group.length > 0) { for (Button button: button_group) { button.visible = value } }
		if (input_group.length > 0) { for (TextInput input: input_group) { input.visible = value } }
		if (graph_group.length > 0) { for (Graph graph: graph_group) { graph.visible = value } }
		if (text_box_group.length > 0) { for (TextBox text_box: text_box_group) { text_box.visible = value } }
	}
	
}


ArrayList<FolderGroup> FOLDERS = new ArrayList<FolderGroup>();

class FolderGroup {
	
	boolean visible;
	UIGroup[] groups;
	Button[] buttons;
	
	int folder = 0;
	
	public FolderGroup(boolean visible_start, int folder_num) {
		visible = visible_start;
		groups = new UIGroup[folder_num];
		buttons = new Button[folder_num];
		
		for (int group = 0; group < folder_num; group++) {
			groups[group] = new UIGroup(visible_start);
			if (group != folder) { groups[group].set_visible(false) }
		}
		
		FOLDERS.add(this);
	}
	

	void addGroup(UIGroup UIgroups) {
		for (int i = 0; i < UIgroups.length; i++) {
			groups[i] = UIgroups[i];
			if (i == folder) { groups[i].set_visible(true) }
			else { groups[i].set_visible(false) }
		}
	}
	
	void addButton(int folder_num, Button[] buttons) { groups[folder_num].addButton(buttons) }

	void addInput(int folder_num, TextInput[] inputs) { groups[folder_num].addInput(inputs) }

	void addGraph(int folder_num, Graph[] graphs) { groups[folder_num].addGraph(graphs) }

	void addTextBox(int folder_num, TextBox[] text_boxes) { groups[folder_num].addTextBox(text_boxes) }

	void addFolderButton(Button[] folder_buttons) {
		for (int i = 0; i < folder_buttons.length; i++) {
			buttons[i] = folder_buttons[i];
			buttons[i].visible = visible;
			if (i == folder) { buttons[i].disabled = true }
		}
	}

	void set_visible(boolean value) {
		group[folder].set_visible(value);
		for (int group = 0; group < groups.length; group++) {
			buttons[group].visible = value;
		}
	}

	void set_folder(int folder_num) {
		folder = folder_num;
		for (int group = 0; group < groups.length; group++) {
			if (group == folder) {
				groups[group].set_visible(true);
				buttons[group].disabled = true;
			} else {
				groups[group].set_visible(false);
				buttons[group].disabled = false;
			}
		}
	}

	void check_buttons() {
		for (int i = 0; i < buttons.length; i++) {
			if (buttons[i].mouseHovering()) { set_folder(i) }
		}
	}
	
}