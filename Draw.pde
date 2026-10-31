PFont monospace = createFont("monospace", 20);
PFont sansserif = createFont("sans-serif", 20);

color reset_color = color(200, 100, 100);

Vector2 one_goal_position = new Vector2(625, 250);

// Settings Booleans
boolean auto = false;
boolean one_goal = true;
boolean prev_one_goal = true;
boolean speed_train = false;
boolean mouse_mode = false;
boolean no_mutate = false;
boolean prev_no_mutate = false;

boolean not_typing = true;
boolean hide_ui = false;

// Misc Variables
boolean running = false;
int set_fps = 60;
int frame_count = 0;
int spectating_num = -1;
int generation = 0;
boolean not_first_gen = false;
int secs_elapsed = 0;

// Population Variables
int time_limit = 10;
int population_size = 50;

// Simulation
Simulation NavSimulation = new Simulation(population_size, 375, 375);

// UIGroups
UIGroup SplashTextGroup = new UIGroup(true);
UIGroup MainControlsGroup = new UIGroup(true);
UIGroup SettingsHomeGroup = new UIGroup(true);
UIGroup Settings1Group = new UIGroup(false);
UIGroup Settings2Group = new UIGroup(false);
UIGroup StatsHomeGroup = new UIGroup(true);
UIGroup StatsGroup = new UIGroup(false);
UIGroup DataGroup = new UIGroup(false);

UIGroup ScoreGraphGroup = new UIGroup(false);

// Folders
FolderGroup SettingsFolder = new FolderGroup(true, 0);
FolderGroup InfoFolder = new FolderGroup(true, 0);
SettingsFolder.addGroup({SettingsHomeGroup, Settings1Group, Settings2Group});
InfoFolder.addGroup({StatsHomeGroup, StatsGroup, DataGroup});

// Splash Text
Button CloseSplashButton = new Button(625, 600, 150, 75, "Close");
	CloseSplashButton.set_align(CENTER, CENTER);
	CloseSplashButton.fill_color = reset_color;
	CloseSplashButton.text_size = 30;
TextBox SplashText = new TextBox(625, 25, 650,
"Welcome to the Evolution Simulator! \n \n " + 
"In this program, the little circles, or robots as they will be called, will try to make their way towards the yellow goal as efficiently as possible. \n \n " + 
"They start off randomly generated, so they are initially not very good at traversing towards the goal, but they will EVOLVE to do better.");
	SplashText.set_align(CENTER, TOP);
SplashTextGroup.addButton({CloseSplashButton});
SplashTextGroup.addTextBox({SplashText});

// Main UI
TextBox GenerationsText = new TextBox(0, 0, 250, "Generation 0");
	GenerationsText.text_wrap = false;
	GenerationsText.set_fixed_height(50);
	GenerationsText.set_text_size(30);
TextBox TimerText = new TextBox(0, 195, 250, "Time: 0.000s");
	TimerText.text_wrap = false;
	TimerText.set_fixed_height(50);
	TimerText.set_text_size(40);

// Main Controls
Button StartButton = new Button(15, 65, 75, 50, "Start");
Button SortButton = new Button(105, 65, 75, 50, "Sort");
	SortButton.disabled = true;
Button KillButton = new Button(15, 130, 75, 50, "Kill");
	KillButton.disabled = true;
Button MutateButton = new Button(105, 130, 75, 50, "Mutate");
	MutateButton.disabled = true;
Button SkipButton = new Button(190, 65, 50, 30, "Skip");
	SkipButton.visible = false;
	SkipButton.fill_color = color(50, 100, 50);
MainControlsGroup.addButton({StartButton, SortButton, KillButton, MutateButton});

// Settings Home
TextBox SettingsInfoText = new TextBox(10, 255, 230,
"Welcome to the Evolution Simulator! \n \n " + 
"In this program, the little circles, or robots as they will be called, will try to make their way towards the yellow goal as efficiently as possible. \n \n " + 
"They start off randomly generated, so they are initially not very good at traversing towards the goal, but they will EVOLVE to do better.");
	SettingsInfoText.set_fixed_height(435);
SettingsHomeGroup.addTextBox({SettingsInfoText});

// Settings 1 Controls
Button AutoButton = new Button(15, 260, 50, 50, "Auto");
Button OneGoalButton = new Button(15, 325, 100, 50, "One Goal");
Button SpeedTrainButton = new Button(15, 390, 125, 50, "Speed Train");
Button MouseModeButton = new Button(15, 455, 125, 50, "Mouse Mode");
Button NoMutateButton = new Button(15, 520, 100, 50, "No Mutate");

TextBox AutoText = new TextBox(75, 285, 50, "false");
	AutoText.text_color = Utils.bool_color(auto);
TextBox OneGoalText = new TextBox(125, 350, 50, "true");
	OneGoalText.text_color = Utils.bool_color(one_goal);
TextBox SpeedTrainText = new TextBox(150, 415, 50, "false");
	SpeedTrainText.text_color = Utils.bool_color(speed_train);
TextBox MouseModeText = new TextBox(150, 480, 50, "false");
	MouseModeText.text_color = Utils.bool_color(mouse_mode);
TextBox NoMutateText = new TextBox(125, 545, 50, "false");
	NoMutateText.text_color = Utils.bool_color(no_mutate);

Settings1Group.addButton({AutoButton, OneGoalButton, SpeedTrainButton, MouseModeButton, NoMutateButton});
Settings1Group.addTextBox({AutoText, OneGoalText, SpeedTrainText, MouseModeText, NoMutateText});

for (TextBox text_box: Settings1Group.text_box_group) {
	text_box.set_align(LEFT, CENTER);
	text_box.background = false;
}

// Settings 2 Controls
Button TimerReset = new Button(15, 325, 100, 50, "Reset");
	TimerReset.fill_color = reset_color;
TextInput TimerInput = new TextInput(15, 260, 165, 50, "Type Seconds");
	TimerInput.num_only = true;
TextBox TimeLimitText = new TextBox(125, 350, 120, "Time Limit: \n " + time_limit + "s");
	TimeLimitText.set_align(LEFT, CENTER);
	TimeLimitText.background = false;
Settings2Group.addButton({TimerReset});
Settings2Group.addInput({TimerInput});
Settings2Group.addTextBox({TimeLimitText});

// Settings Folder Buttons
Button SettingsHomeButton = new Button(0, 700, 50, 50, "\u2302");
	SettingsHomeButton.text_size = 40;
Button Settings1Button = new Button(50, 700, 100, 50, "Settings 1");
Button Settings2Button = new Button(150, 700, 100, 50, "Settings 2");
SettingsFolder.addFolderButton({SettingsHomeButton, Settings1Button, Settings2Button});

// Info/Stats Home
TextBox StatsInfoText = new TextBox(1010, 10, 230,
"Various settings can be found in the tabs on the left that can control certain aspects of the simulation. All controls and menus have accompanying help text for more information. \n \n " + 
"This panel will display information about the robots and statistical trends across the entire simulation. \n \n " + 
"STATS: \n Allows you to view any particular robot more clearly and some of its characteristics. \n \n " + 
"DATA: \n Shows graphs and some important data. \n \n " + 
"(More information can be found in their respective tabs below.)");
	StatsInfoText.set_fixed_height(680);
StatsHomeGroup.addTextBox({StatsInfoText});

// Stats
TextInput SpectateInput = new TextInput(1075, 125, 100, 100, "#");
	SpectateInput.text_size = 50;
	SpectateInput.num_only = true;
	SpectateInput.default_value = "Type #";
TextBox StatsText = new TextBox(1125, 312.5, 200, "...");
	StatsText.set_align(CENTER, CENTER);
Button StopSpectateButton = new Button(1125, 400, 150, 50, "Stop Spectating");
	StopSpectateButton.set_align(CENTER, TOP);
	StopSpectateButton.disabled = true;
	StopSpectateButton.fill_color = reset_color;
TextBox SpectateText = new TextBox(1000, 0, 250, "Spectate");
	SpectateText.set_fixed_height(60);
	SpectateText.set_text_size(30);
StatsGroup.addButton({StopSpectateButton});
StatsGroup.addInput({SpectateInput});
StatsGroup.addTextBox({StatsText, SpectateText});

// Data
Button ScoreGraphButton = new Button(1125, 75, 150, 75, "Score Graph\nShow");
	ScoreGraphButton.set_align(CENTER, TOP);
TextBox GraphsText = new TextBox(1000, 0, 250, "Graphs");
	GraphsText.set_fixed_height(60);
	GraphsText.set_text_size(30);
	GraphsText.text_wrap = false;
TextBox SimTimeText = new TextBox(1000, 600, 250, "Simulated Time 0m 0s");
	SimTimeText.set_fixed_height(100);
	SimTimeText.set_text_size(30);
	SimTimeText.text_wrap = false;
DataGroup.addButton({ScoreGraphButton});
DataGroup.addTextBox({SimTimeText, GraphsText});

// Info Folder Buttons
Button StatsHomeButton = new Button(1000, 700, 50, 50, "\u2302");
	StatsHomeButton.text_size = 40;
Button StatsButton = new Button(1050, 700, 100, 50, "Stats");
Button DataButton = new Button(1150, 700, 100, 50, "Data");
InfoFolder.addFolderButton({StatsHomeButton, StatsButton, DataButton});

// Score Graph
Graph ScoreGraph = new Graph(300, 40, 650, 325, "Generation", "Score", 10);
	ScoreGraph.set_y_range({0,1});
	ScoreGraph.line_colors = {color(255,255,0), 50, 50, 50, 50, color(255,0,0), 50, 50, 50, 50};
	ScoreGraph.line_weights = {4, 2, 2, 2, 2, 4, 2, 2, 2, 2};
	ScoreGraph.line_visibles = {true, false, false, false, false, true, false, false, false, false}
	ScoreGraph.lines_per_unitX = 1;
	ScoreGraph.fill_color = 150;

Button PercentilesButton = new Button(1062.5, 175, 125, 50, "10th %iles\nShow");
	PercentilesButton.text_color = color(0);
Button MedianButton = new Button(1187.5, 175, 125, 50, "Median\n0.000 Hide");
	MedianButton.text_color = color(255, 0, 0);
	MedianButton.toggled = true;
Button BestScoreButton = new Button(1062.5, 225, 125, 50, "Top Score\n0.000 Hide");
	BestScoreButton.text_color = color(255, 255, 0);
	BestScoreButton.toggled = true;
Button BestMedianButton = new Button(1187.5, 225, 125, 50, "Best Median\n0.000 Hide");
	BestMedianButton.text_color = color(255, 0, 255);
	BestMedianButton.toggled = true;

text_box_scalar = 1.15;
TextBox ScoreGraphInfoText = new TextBox(625, 425, 700, 
"The Score Graph \n \n " + 
"This graph shows the scores of a variety of robots across every generation. It displays the scores of each 10th percentile robot (if enabled, minus a few of the bottom percentiles), " + 
"as well as the median (50th percentile) and the best robot (100th percentile). The very top of the graph is the overall best score achieved across every generation. \n \n " + 
"Using this graph, you can see how the robots improve and how the population becomes better and better over time. It should be noted that the bottom percentiles tend to fluctuate up and down " + 
"a large amount due to some of the random mutations of the robots creating ineffective outcomes. This does not mean the robots are struggling, those are just the outliers.");
text_box_scalar = 1.1;
	ScoreGraphInfoText.set_align(CENTER, TOP);
ScoreGraphGroup.addButton({PercentilesButton, MedianButton, BestScoreButton, BestMedianButton});
ScoreGraphGroup.addGraph({ScoreGraph});
ScoreGraphGroup.addTextBox({ScoreGraphInfoText});

for (Button button: ScoreGraphGroup.button_group) {
	button.set_align(CENTER, TOP);
	button.toggle_var = true;
}

Button ToggleScoreInfoButton = new Button(275, 425, 100, 50, "Info Text\nHide");
	ToggleScoreInfoButton.set_priority(true);
	ToggleScoreInfoButton.toggle_var = true;
	ToggleScoreInfoButton.toggled = true;
ScoreGraphGroup.addButton({ToggleScoreInfoButton});

// Main Controls Help Buttons
text_box_scalar = 1.15;
HelpButton MainControlsHelp = new HelpButton(200, 122.5, 30, 30, 1000,
"These are the main controls of the simulator. \n \n " + 
"Start - Starts the simulation for the current generation of robots. \n \n " + 
"Sort - After the generation is finished simulating, this button sorts the robots based on how well they did at navigating towards the yellow goal (their score). \n \n " + 
"Kill - \"Kills\" the bottom 50% of (sorted) robots, allowing the simulation to filter out the bad performing robots and allow the good preforming robots to live on to the next generation. \n \n " + 
"Mutate - Allows the top performing robots to \"reproduce\", where the brains of the top performing robots are copied into the bottom performing robots with some random changes (mutations). " + 
"This causes the good traits of the top robots to spread to the rest of the population, which increases the average performance of the robots. " + 
"The random changes also cause (by chance) certain robots to improve upon the previous generations good traits. \n \n " + 
"(The Skip button skips the sort, kill, and mutate sections)");
text_box_scalar = 1.1;
	MainControlsHelp.set_align(LEFT, CENTER);
	MainControlsHelp.top_align = true;
MainControlsGroup.addButton({MainControlsHelp});

// Settings 1 Help Buttons
HelpButton AutoHelp = new HelpButton(210, 270, 30, 30, 200,
"Makes the simulation run automatically.");
HelpButton OneGoalHelp = new HelpButton(210, 335, 30, 30, 200,
"Makes the goal stay in one position between generations. If false, the goal will move between generations.");
HelpButton SpeedTrainHelp = new HelpButton(210, 400, 30, 30, 200,
"Makes the simulation run extremely fast (without visuals). WARNING: This will causes issues when interacting with the menus if Auto is also on, so disable this before interacting with anything else.");
HelpButton MouseModeHelp = new HelpButton(210, 465, 30, 30, 200,
"Makes the goal follow your mouse/cursor when holding the left mouse button. Best used with the No Mutate setting.");
HelpButton NoMutateHelp = new HelpButton(210, 530, 30, 30, 200,
"Prevents the robots from mutating after a generation.");
Settings1Group.addButton({AutoHelp, OneGoalHelp, SpeedTrainHelp, MouseModeHelp, NoMutateHelp});

// Settings 2 Help Buttons
HelpButton TimeLimitHelp = new HelpButton(200, 270, 30, 30, 200,
"Allows you to change the time limit for each generation. Enter value in seconds. The base value is 10 seconds and can be reset with the Reset button.");
Settings2Group.addButton({TimeLimitHelp});

// Spectate Help Buttons
text_box_scalar = 1.15;
HelpButton SpectateHelp = new HelpButton(1200, 30, 30, 30, 350,
"Input a number to spectate that number robot. Also displays some of the stats of that robot. \n \n " + 
"ID - The number dispalyed on the face of the robot. Used to identify and differentiate the robots. \n \n " + 
"NAME - Randomly generated for each robot just for fun. It has nothing to do with the performance of the robots. \n \n " + 
"SCORE - Represents how well the robot is going towards the goal, or how efficiently the robot navigates towards the goal. Used in all parts of the simulation from sorting to keeping track of data.");
text_box_scalar = 1.1;
	SpectateHelp.right_align = true;
	SpectateHelp.top_align = true;
	SpectateHelp.set_align(LEFT, CENTER);
	SpectateHelp.set_priority(true);
	SpectateHelp.help_text.set_priority(true);
StatsGroup.addButton({SpectateHelp});

// Data Help Buttons
HelpButton GraphHelp = new HelpButton(1200, 30, 30, 30, 200, 
"These graphs show data collected across every generation of the simulation to show trends and the general performance of the robots.");
	GraphHelp.right_align = true;
	GraphHelp.top_align = true;
	GraphHelp.set_align(LEFT, CENTER);
	GraphHelp.set_priority(true);
	GraphHelp.help_text.set_priority(true);
text_box_scalar = 1.15;
HelpButton DataHelp = new HelpButton(1010, 350, 30, 30, 350,
"This menu shows the best and median robots for the listed generation and some of their stats. It also shows whether the robot achieved a new best or new best median score for that generation. \n \n " + 
"Below this is displayed the total amount of time the robots have been training for, or the simulated time. This helps give a sense of scale.");
text_box_scalar = 1.1;
	DataHelp.right_align = true;
	DataHelp.set_align(LEFT, CENTER);
DataGroup.addButton({DataHelp, GraphHelp});

// Graph Help Buttons
HelpButton ScoreGraphTogglesHelp = new HelpButton(1125, 285, 30, 30, 200,
"These buttons act as a color-coded key for the different features of the Score Graph, as well as toggling on and off certain features of the Score Graph so you can view certain features more clearly.");
	ScoreGraphTogglesHelp.set_align(CENTER, TOP);
	ScoreGraphTogglesHelp.right_align = true;
	ScoreGraphTogglesHelp.top_align = true;
ScoreGraphGroup.addButton({ScoreGraphTogglesHelp});



void draw_items() {
  background(100);

  // Border Rectangles
  fill(75);
  rect(0, 0, 250, SQUARE_SIZE);
  rect(1000, 0, 250, SQUARE_SIZE);

  // Base UI
  fill(255);
  textSize(20);
	textAlign(LEFT, BOTTOM);
  text("FPS " + round(frameRate), 255, height);
	
	// Spectate
	if (StatsGroup.visible) {
		fill(robot_color);
		ellipse(1125, 175, 200, 200);
		
		if (SpectateInput.value <= population_size && SpectateInput.value != "" && !SpectateInput.typing) {
			StatsText.set_text(
				"ID: " + SpectateInput.value + " \n " + 
				"Name: \"" + NavSimulation.population[SpectateInput.value - 1].name + "\" \n " + 
				"Score: " + Utils.dec_precision(NavSimulation.scores[SpectateInput.value - 1], 3), 20);
		}
	}
	
	// Data
	if (DataGroup.visible) {

		fill(100);
		rect(1000, 325, 250, 50);

		// Robot Stats
		fill(robot_color);
		ellipse(1070, 437.5, 90, 90);
		ellipse(1180, 437.5, 90, 90);

		fill(255);
		textAlign(CENTER, CENTER);
		textSize(25);
		if (not_first_gen) { text("Generation " + (generation - 1), 1125, 350) }
		else { text("Generation ...", 1125, 350) }

		textSize(15);
		text("Top Robot", 1070, 500);
		text("Median Robot", 1180, 500);

		if (not_first_gen) {

			text("\"" + NavSimulation.top_robot.name + "\"", 1070, 525);
			text("\"" + NavSimulation.median_robot.name + "\"", 1180, 525);

			text("Score: " + Utils.dec_precision(NavSimulation.top_score, 3), 1070, 550);
			text("Score: " + Utils.dec_precision(NavSimulation.median_score, 3), 1180, 550);
			
			if (NavSimulation.new_best_score) {
				fill(255, 255, 0);
				text("New Best!", 1070, 575);
			}
			if (NavSimulation.new_best_median) {
				fill(255, 0, 255);
				text("New Best!", 1180, 575);
			}

			fill(255);
			textSize(40);
			text(NavSimulation.top_robot.id, 1070, 437.5);
			text(NavSimulation.median_robot.id, 1180, 437.5);

		}
	}

}


void showUI() {
	for (Button button: BUTTONS) { button.show() }
	for (TextInput input: TEXTINPUTS) { input.show() }
	for (Graph graph: GRAPHS) { graph.show() }
	for (TextBox text_box: TEXTBOXES) { text_box.show() }
	for (HelpButton help: HELPBUTTONS) { help.show_help() }
	for (UI ui: PRIORITY_UI) { ui.show() }
}


void checkUI() {
	for (FolderGroup folder: FOLDERS) { folder.check_buttons() }
  for (Button button: BUTTONS) {
    if (button.mouseHovering()) { button.press() }
  }
	for (TextInput input: TEXTINPUTS) { input.press() }
}


void toggle_buttons() {
	for (Button button: BUTTONS) {
		if (button.mouseHovering()) { button.flip_toggle() }
	}
}


void Startfunc() {
	
	if (one_goal != prev_one_goal) {
		ScoreGraph.add_markerX(generation, color(0,255,0), "One Goal = " + one_goal, true, true);
		prev_one_goal = one_goal;
	}
	if (no_mutate != prev_no_mutate) { prev_no_mutate = no_mutate }
	
	NavSimulation.reset_robots();
	NavSimulation.reset_scores();
	if (!one_goal) { NavSimulation.randomize_goal() } else { NavSimulation.goal.position = one_goal_position }
	running = true;
	if (!no_mutate) {
		generation += 1;
		GenerationsText.set_text("Generation " + generation, 30);
	}
	
	SkipButton.visible = false;
	
}


void Endfunc() {
	
	NavSimulation.end_fitness_func(time_limit);
	NavSimulation.sort_robots();
	// NavSimulation.color_code_robots();
	running = false;
	SortButton.disabled = false;
	frame_count = 0;

	ScoreGraph.clear_markersY();
	ScoreGraph.add_markerY(NavSimulation.top_score, color(255, 255, 0), Utils.dec_precision(NavSimulation.top_score, 3), false, false);
	ScoreGraph.add_markerY(NavSimulation.median_score, color(255, 0, 0), Utils.dec_precision(NavSimulation.median_score, 3), false, false);
	ScoreGraph.add_markerY(NavSimulation.best_score, color(255, 255, 0), "", true, true);
	ScoreGraph.add_markerY(NavSimulation.best_median, color(255, 0, 255), Utils.dec_precision(NavSimulation.best_median, 3), true, true);
	
	MedianButton.label = "Median\n" + Utils.dec_precision(NavSimulation.median_score, 3) + " " + Utils.bool_showhide(MedianButton.toggled);
	BestScoreButton.label = "Top Score\n" + Utils.dec_precision(NavSimulation.top_score, 3) + " " + Utils.bool_showhide(BestScoreButton.toggled);
	BestMedianButton.label = "Best Median\n" + Utils.dec_precision(NavSimulation.best_median, 3) + " " + Utils.bool_showhide(BestMedianButton.toggled);
	
	ScoreGraph.set_y_range({0, NavSimulation.best_score});

	if (!prev_no_mutate) {
		for (int i = 0; i <= 9; i++) {
			ScoreGraph.add_value(NavSimulation.scores[NavSimulation.sorted_population[max(0, (i * (population_size / 10)) - 1)]], i);
		}
	}
	
	secs_elapsed += int(time_limit);
	SimTimeText.set_text("Simulated Time\n" + int(secs_elapsed / 60) + "m " + secs_elapsed % 60 + "s", 30);
	not_first_gen = true;
	
	SkipButton.visible = true;
	
}


void setup() {
  size(SQUARE_SIZE + 500, SQUARE_SIZE);
	frameRate(set_fps);
}


void draw() {
	
	if (mouse_mode && mousePressed && mouseButton == LEFT) { NavSimulation.goal.position = new Vector2(constrain(mouseX - 250, 0, 750), mouseY) }
  
  draw_items();
	NavSimulation.show_all();
  
  if (running) {
		if (speed_train) {
			while (frame_count < time_limit * 60) {
				NavSimulation.update_robots();
				NavSimulation.fitness_func(time_limit);
				frame_count++;
			}
		} else {
			NavSimulation.update_robots();
			NavSimulation.fitness_func(time_limit);
			frame_count++;
			TimerText.set_text("Time: " + Utils.dec_precision(frame_count / 60, 3) + "s", 40);
		}
  }
  
  if (frame_count >= time_limit * 60) { Endfunc() }

	if (auto && !running) {
		if (not_first_gen) {
			NavSimulation.kill_robots(50);
			NavSimulation.mutate_robots(50);
		}
		Startfunc();
	}
	
	
	// Put here so they render over everything else
	if (ScoreGraph.visible) {
		fill(100);
		rect(250, 0, SQUARE_SIZE, SQUARE_SIZE);
	}
	
	showUI();
	
	if (hide_ui) {
		fill(75);
		rect(0, 245, 250, 505);
		rect(1000, 0, 250, 750);
	}
	
	if (SplashTextGroup.visible) {
		background(100);
		for (Button button: SplashTextGroup.button_group) { button.show() }
		for (TextBox text_box: SplashTextGroup.text_box_group) { text_box.show() }
	}
	
	if (!no_mutate) { SpeedTrainButton.disabled = false }
}


void mouseClicked() {
	
	// Splash Text
	
	if (CloseSplashButton.mouseHovering()) {
		SplashTextGroup.set_visible(false);
	}
	
	// Main Controls
	
  if (StartButton.mouseHovering()) {
    StartButton.disabled = true;
		Startfunc();
  }
  
  if (SortButton.mouseHovering()) {
		SortButton.disabled = true;
		if (!no_mutate) { KillButton.disabled = false } else { StartButton.disabled = false }
    NavSimulation.arrange_robots_byscore();
		NavSimulation.reset_goal();
  }
	
	if (KillButton.mouseHovering()) {
		KillButton.disabled = true;
		MutateButton.disabled = false;
		NavSimulation.kill_robots(50);
	}
	
	if (MutateButton.mouseHovering()) {
		MutateButton.disabled = true;
		StartButton.disabled = false;
		SkipButton.visible = false;
		NavSimulation.mutate_robots(50);
	}
	
	if (SkipButton.mouseHovering()) {
		if (!SortButton.disabled) {
			NavSimulation.arrange_robots_byscore();
			NavSimulation.reset_goal();
		}
		if (!SortButton.disabled || !KillButton.disabled) { NavSimulation.kill_robots(50); }
		if (!SortButton.disabled || !KillButton.disabled || !MutateButton.disabled) { NavSimulation.mutate_robots(50); }
		StartButton.disabled = false;
		SortButton.disabled = true;
		KillButton.disabled = true;
		MutateButton.disabled = true;
	}
	
	// Settings 1
	
	if (AutoButton.mouseHovering()) {
		auto = !auto;
		AutoText.set_text(auto, 20);
		AutoText.text_color = Utils.bool_color(auto);
		
		MainControlsGroup.set_visible(!auto);
		StartButton.disabled = true;
		SortButton.disabled = true;
		KillButton.disabled = true;
		MutateButton.disabled = true;
	}
  
	if (OneGoalButton.mouseHovering()) {
		one_goal = !one_goal;
		OneGoalText.set_text(one_goal, 20);
		OneGoalText.text_color = Utils.bool_color(one_goal);
	}
	
	if (SpeedTrainButton.mouseHovering()) {
		if (!no_mutate) {
			speed_train = !speed_train
			SpeedTrainText.set_text(speed_train, 20);
			SpeedTrainText.text_color = Utils.bool_color(speed_train);
		}
	}
	
	if (MouseModeButton.mouseHovering()) {
		mouse_mode = !mouse_mode;
		MouseModeText.set_text(mouse_mode, 20);
		MouseModeText.text_color = Utils.bool_color(mouse_mode);
	}
	
	if (NoMutateButton.mouseHovering()) {
		no_mutate = !no_mutate;
		NoMutateText.set_text(no_mutate, 20);
		NoMutateText.text_color = Utils.bool_color(no_mutate);
		
		if (no_mutate) {
			auto = false;
			AutoText.set_text(auto, 20);
			AutoText.text_color = Utils.bool_color(auto);
			speed_train = false;
			SpeedTrainText.set_text(speed_train, 20);
			SpeedTrainText.text_color = Utils.bool_color(speed_train);
			AutoButton.disabled = true;
			SpeedTrainButton.disabled = true;
		} else {
			AutoButton.disabled = false;
			SpeedTrainButton.disabled = false;
		}
	}
	
	// Settings 2
	
	if (TimerReset.mouseHovering()) {
		time_limit = 10;
		TimeLimitText.set_text("Time Limit: 10s", 20);
	}
	
	// Spectate
	
	if (StopSpectateButton.mouseHovering()) {
		SpectateInput.value = "";
		for (Robot robot: NavSimulation.population) { robot.spectating = true }
		StatsText.set_text("...", 20);
		StopSpectateButton.disabled = true;
		NavSimulation.clear_priority();
	}
	
	// Score Graph
	
	if (ScoreGraphButton.mouseHovering()) {
		ScoreGraphGroup.set_visible(!ScoreGraphGroup.visible);
		if (ScoreGraphGroup.visible) { ScoreGraphButton.label = "Score Graph\nHide" } else { ScoreGraphButton.label = "Score Graph\nShow" }
	}
	
	// Stats Folder Buttons
	
	if (StatsButton.mouseHovering() || StatsHomeButton.mouseHovering()) {
		ScoreGraphGroup.set_visible(false);
		ScoreGraphButton.label = "Score Graph\nShow";
	}
	
	toggle_buttons();
	// PUT TOGGLING BUTTON CODES AFTER THIS
	
	// Score Graph
	
	if (PercentilesButton.mouseHovering()) {
		PercentilesButton.label = "10th %iles\n" + Utils.bool_showhide(PercentilesButton.toggled);
		for (int i = 1; i < 10; i++) {
			if (i != 5) { ScoreGraph.line_visibles[i] = PercentilesButton.toggled }
		}
	}
	
	if (MedianButton.mouseHovering()) {
		MedianButton.label = "Median\n" + Utils.dec_precision(NavSimulation.median_score, 3) + " " + Utils.bool_showhide(MedianButton.toggled);
		ScoreGraph.line_visibles[5] = MedianButton.toggled;
		ScoreGraph.markersY_visibles[1] = MedianButton.toggled;
	}
	
	if (BestScoreButton.mouseHovering()) {
		BestScoreButton.label = "Top Score\n" + Utils.dec_precision(NavSimulation.top_score, 3) + " " + Utils.bool_showhide(BestScoreButton.toggled);
		ScoreGraph.line_visibles[0] = BestScoreButton.toggled;
		ScoreGraph.markersY_visibles[0] = BestScoreButton.toggled;
	}
	
	if (BestMedianButton.mouseHovering()) {
		BestMedianButton.label = "Best Median\n" + Utils.dec_precision(NavSimulation.best_median, 3) + " " + Utils.bool_showhide(BestMedianButton.toggled);
		ScoreGraph.markersY_visibles[3] = BestMedianButton.toggled;
	}
	
	if (ToggleScoreInfoButton.mouseHovering()) {
		ToggleScoreInfoButton.label = "Info Text\n" + Utils.bool_showhide(ToggleScoreInfoButton.toggled);
		if (ToggleScoreInfoButton.toggled) {
			ToggleScoreInfoButton.set_position(275, 425);
			ScoreGraphInfoText.set_position(625, 425);
			ScoreGraphInfoText.set_dynamic_height();
			text_box_scalar = 1.15;
			ScoreGraphInfoText.set_text(
			"The Score Graph \n \n " + 
			"This graph shows the scores of a variety of robots across every generation. It displays the scores of each 10th percentile robot (if enabled, minus a few of the bottom percentiles), " + 
			"as well as the median (50th percentile) and the best robot (100th percentile). The very top of the graph is the overall best score achieved across every generation. \n \n " + 
			"Using this graph, you can see how the robots improve and how the population becomes better and better over time. It should be noted that the bottom percentiles tend to fluctuate up and down " + 
			"a large amount due to some of the random mutations of the robots creating ineffective outcomes. This does not mean the robots are struggling, those are just the outliers.", 20);
			text_box_scalar = 1.1;
			ScoreGraph.height = 325;
		} else {
			ToggleScoreInfoButton.set_position(275, 375 + ScoreGraphInfoText.height);
			ScoreGraphInfoText.set_position(625, 375 + ScoreGraphInfoText.height);
			ScoreGraphInfoText.set_text("...", 20);
			ScoreGraphInfoText.set_fixed_height(50);
			ScoreGraph.height = 600;
		}
		if (not_first_gen) { ScoreGraph.set_y_range({0, NavSimulation.best_score}) }
	}
	
	checkUI();
}


void keyTyped() {

	if (key == 'h' || key == 'H') {
		for (TextInput input: TEXTINPUTS) {
			if (input.typing) {
				not_typing = false;
				break;
			} else { not_typing = true }
		}
		if (not_typing) { hide_ui = !hide_ui }
	}
	
	// TEXT INPUTS
	for (TextInput input: TEXTINPUTS) {
		if (input.typing) {
			if (key == ENTER || key == RETURN) {
				input.typing = false;
				if (input.num_only) { input.filter_num() }
				
				// PUT TEXT INPUT CODE HERE
				// e.g if (input == TEXT INPUT) {...}
				
				// Spectate
				if (input == SpectateInput) {
					
					NavSimulation.clear_priority();
					
					if (SpectateInput.value == "" || SpectateInput.value > population_size) {
						for (Robot robot: NavSimulation.population) { robot.spectating = true }
						if (SpectateInput.value > population_size) { StatsText.set_text("Number too large", 20) } else { StatsText.set_text("...", 20) }
						StopSpectateButton.disabled = true;
						
					} else if (SpectateInput.value <= population_size) {
						for (Robot robot: NavSimulation.population) {
							
							if (robot.id == SpectateInput.value) {
								robot.spectating = true;
								NavSimulation.add_priority_robot({robot});
							} else { robot.spectating = false }	
						}
						StatsText.set_text(
							"ID: " + SpectateInput.value + " \n " + 
							"Name: \"" + NavSimulation.population[SpectateInput.value - 1].name + "\" \n " + 
							"Score: " + Utils.dec_precision(NavSimulation.scores[SpectateInput.value - 1], 3), 20);
						StopSpectateButton.disabled = false;
					}
				}
				
				// Timer
				if (input == TimerInput) {
					if (TimerInput.value >= 1) {
						time_limit = TimerInput.value;
						TimeLimitText.set_text("Time Limit: " + time_limit + "s", 20);
					}
				}
				
			} else {
				input.value += String(key);
			}
		}
	}
	
}