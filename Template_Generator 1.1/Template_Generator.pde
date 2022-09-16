/**
 * NAME    : Template Generator
 * DESC    : Creates data template for letter recognition program.
 * AUTHOR  : John Yoon
 * DATE    : 2022/09/14
 * VERSION : 1.1
 *
 * PRESS '[a-z]' : add new data to the template (cache data)
 * PRESS 'ENTER' : export the data (json file)
 * PRESS 'SPACE' : print template info
 * PRESS 'ESC'   : discard the data on the screen
 * PRESS 'CTRL'  : open other template
 *
 * Written by, Processing 4.0.1.
 * Copyright 2022, John Yoon, All rights reserved.
 */

// SETTING - GENERAL //
private final String VERSION = "1.0.1";
private final int WIDTH = 800;
private final int HEIGHT = 800;
private final int FPS = 60;
private final String SPLIT_PATTERN = "|";
private final int MINIMUM_STROKE = 10;

// SETTING - FILE //
private final String templatePath = "dist/";
private final String templateName = "templates.json";

// GLOBAL VARIABLES //
private ArrayList<Coordinate> coor;
private Template templateData;

void setup() {
  // GENERAL FRAME SETTING
  size(800, 800); // default setting
  surface.setSize(WIDTH, HEIGHT);
  background(255);
  surface.setTitle("Template Generator 1.1 by John Yoon");
  surface.setResizable(false);
  smooth(3);
  frameRate(FPS);

  // VARIABLES
  coor = new ArrayList<Coordinate>();
  templateData = new Template(templatePath, templateName, VERSION, WIDTH, HEIGHT, FPS, SPLIT_PATTERN, MINIMUM_STROKE);

  // PRINT INSTRUCTIONS
  println("PRESS '[a-z]' : add new data to the template (cache data)");
  println("PRESS 'ENTER' : export the data (json file)");
  println("PRESS 'SPACE' : print template info");
  println("PRESS 'ESC'   : discard the data on the screen");
  println("PRESS 'CTRL'  : open other template");
}

void draw() {
  stroke(0);
  strokeWeight(16);

  if (mousePressed && mouseButton == LEFT) {
    coor.add(new Coordinate(mouseX, mouseY));

    if (coor.size() > 1 && coor.get(coor.size() - 2) != null && coor.get(coor.size() - 1) != null) {
      line(coor.get(coor.size() - 2).getX(), coor.get(coor.size() - 2).getY(),
        coor.get(coor.size() - 1).getX(), coor.get(coor.size() - 1).getY());
    }
  } else if (!mousePressed && !coor.isEmpty() && coor.get(coor.size() - 1) != null) {
    coor.add(null);
  }
}

void keyPressed() {
  if (keyCode == ESC || keyCode == BACKSPACE) {
    coor.clear();
    background(255);
  } else if (keyCode == CONTROL) {
    selectInput("Select the JSON file.", "fileSelected");
  } else if (keyCode == ENTER || keyCode == RETURN) {
    templateData.saveTemplatesFile();
  } else if (keyCode >= 65 && keyCode <= 90) {
    templateData.saveData(key, Encoder.encode(coor, SPLIT_PATTERN));
    println("\'" + key + "\' is Stored");
    coor.clear();
    background(255);
  } else if (key == ' ') {
    templateData.printTemplateInfo();
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Template Selection Canceled.");
  } else if (!selection.getPath().substring(selection.getPath().length() - 5).toLowerCase().equals(".json")) {
    println("Selected file is not .json template file");
  } else {
    String path = selection.getParent() + "\\";
    String name = selection.getName();
    templateData.isAbsolutePath();
    templateData.changeTemplateFile(path, name);
  }
}
