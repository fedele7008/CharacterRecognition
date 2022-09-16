public class Template {

  /**
   * Inner class of Template that stores string encoded data and unique id of the data
   */
  private class Package {
    public final int id;
    public String rawData;
    public String refinedData;

    public Package(int id, String rawData, String refinedData) {
      this.id = id;
      this.rawData = rawData;
      this.refinedData = refinedData;
    }
  }

  /**
   * Inner class of Template that stores the character and the collection of packaged data that represents the character
   */
  private class Contents {
    private char character;
    private ArrayList<Package> packages;

    public Contents(char character) {
      this.character = character;
      this.packages = new ArrayList<Package>();
    }

    public Contents(char character, ArrayList<Package> packages) {
      this.character = character;
      this.packages = packages;
    }

    public char getCharacter() {
      return this.character;
    }

    public ArrayList<Package> getPackages() {
      return this.packages;
    }

    public void addPackage(String data) {
      int maxID = 0;

      for (int i = 0; i < packages.size(); i++) {
        if (packages.get(i).id > maxID) maxID = packages.get(i).id;
      }

      this.packages.add(new Package(maxID + 1, data, ""));
    }
  }

  // FIELDS
  private final String m_version;
  private final int m_sizeX;
  private final int m_sizeY;
  private final int m_fps;
  private final String m_splitPattern;
  private final int m_minStroke;

  private String path;
  private String name;
  private String version;
  private String date;
  private int sizeX;
  private int sizeY;
  private int fps;
  private String splitPattern;
  private int minStroke;
  private ArrayList<Contents> contents;
  private boolean isAbsolutePath;

  public Template(String path, String name, String version, int sizeX, int sizeY, int fps, String splitPattern, int minStroke) {
    // Set variables
    this.m_version = version;
    this.m_sizeX = sizeX;
    this.m_sizeY = sizeY;
    this.m_fps = fps;
    this.m_splitPattern = splitPattern;
    this.m_minStroke = minStroke;
    this.path = path;
    this.name = name;
    this.version = version;
    this.date = String.valueOf(year()) + "/" + String.valueOf(month()) + "/" + String.valueOf(day());
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.fps = fps;
    this.splitPattern = splitPattern;
    this.minStroke = minStroke;
    this.contents = new ArrayList<Contents>();
    this.isAbsolutePath = false;

    File f = dataFile(path + name);

    if (!f.isFile()) { // If json template does not exist, create an empty one.
      JSONObject setting = new JSONObject();
      setting.setInt("sizeX", this.sizeX);
      setting.setInt("sizeY", this.sizeY);
      setting.setInt("fps", this.fps);
      setting.setString("split-pattern", this.splitPattern);
      setting.setInt("minimum-stroke", 10);

      JSONArray contents = new JSONArray();

      JSONObject json = new JSONObject();
      json.setString("version", this.version);
      json.setString("date", this.date);
      json.setJSONObject("setting", setting);
      json.setJSONArray("contents", contents);

      saveJSONObject(json, "data/" + path + name);
      println("Creating a new template in \'" + f.getPath() + "\'.");
      loadTemplatesFile();
      println("Template Generator ready.");
    } else if (!isJsonMatch()) { // If json template already exist, check if it matches our system.
      println("Please re-select the templates file (.json) by pressing 'CTRL' or exit the program");
      println("[POSSIBLE SOLUTION]: remove " + f.getPath() + ". (caution: this will delete previous data)");
    } else {
      loadTemplatesFile();
      println("Template Generator ready.");
    }
  }

  public void isAbsolutePath() {
    this.isAbsolutePath = true;
  }

  public void isRelativePath() {
    this.isAbsolutePath = false;
  }

  public void saveData(char c, String rawData) {
    for (int i = 0; i < contents.size(); i++) {
      if (contents.get(i).getCharacter() == c) {
        contents.get(i).addPackage(rawData);
        return;
      }
    }

    Contents newContent = new Contents(c);
    newContent.addPackage(rawData);
    contents.add(newContent);
  }

  public Boolean changeTemplateFile(String path, String name) {
    if (!isJsonMatch(path, name)) {
      println("Please re-select the templates file (.json) by pressing 'CTRL' or exit the program");
      return false;
    } else {
      this.path = path;
      this.name = name;
      loadTemplatesFile();
      println("New file selected: " + path + name);
      return true;
    }
  }

  private boolean isJsonMatch(String path, String name) {
    JSONObject json;
    if (this.isAbsolutePath) {
      json = loadJSONObject(path + name);
    } else {
      json = loadJSONObject("data/" + path + name);
    }
    String loadedVersion = json.getString("version");
    JSONObject loadedSetting = json.getJSONObject("setting");
    int loadedSizeX = loadedSetting.getInt("sizeX");
    int loadedSizeY = loadedSetting.getInt("sizeY");
    int loadedFps = loadedSetting.getInt("fps");
    String loadedSplitPattern = loadedSetting.getString("split-pattern");
    int loadedMinStroke = loadedSetting.getInt("minimum-stroke");

    boolean result = true;
    ArrayList<String> missmatchingList = new ArrayList<String>();

    if (!loadedVersion.equals(this.m_version)) {
      result = false;
      missmatchingList.add("Version");
    }

    if (loadedSizeX != this.m_sizeX) {
      result = false;
      missmatchingList.add("Width of the canvas");
    }

    if (loadedSizeY != this.m_sizeY) {
      result = false;
      missmatchingList.add("Height of the canvas");
    }

    if (loadedFps != this.m_fps) {
      result = false;
      missmatchingList.add("FPS");
    }

    if (!loadedSplitPattern.equals(this.m_splitPattern)) {
      result = false;
      missmatchingList.add("Split Pattern");
    }

    if (loadedMinStroke != this.m_minStroke) {
      result = false;
      missmatchingList.add("Minumum Stroke");
    }

    if (!result) {
      println("The following data miss-matches current system: ");

      for (int i = 0; i < missmatchingList.size(); i++) {
        println(" * " + missmatchingList.get(i));
      }
    }

    return result;
  }

  private boolean isJsonMatch() {
    return isJsonMatch(this.path, this.name);
  }

  private void loadTemplatesFile() {
    contents.clear();
    JSONObject json;
    if (this.isAbsolutePath) {
      json = loadJSONObject(path + name);
    } else {
      json = loadJSONObject("data/" + path + name);
    }

    version = json.getString("version");
    JSONObject setting = json.getJSONObject("setting");
    sizeX = setting.getInt("sizeX");
    sizeY = setting.getInt("sizeY");
    fps = setting.getInt("fps");
    splitPattern = setting.getString("split-pattern");
    minStroke = setting.getInt("minimum-stroke");
    JSONArray jsonContents = json.getJSONArray("contents");

    for (int i = 0; i < jsonContents.size(); i++) {
      char character = jsonContents.getJSONObject(i).getString("character").charAt(0);
      JSONArray templates = jsonContents.getJSONObject(i).getJSONArray("templates");

      ArrayList<Package> packages = new ArrayList<Package>();
      for (int j = 0; j < templates.size(); j++) {
        int id = templates.getJSONObject(j).getInt("id");
        String rawData = templates.getJSONObject(j).getString("raw-data");
        String refinedData = templates.getJSONObject(j).getString("refined-data");

        packages.add(new Package(id, rawData, refinedData));
      }

      contents.add(new Contents(character, packages));
    }
  }

  private void saveTemplatesFile() {
    JSONArray jsonContents = new JSONArray();

    for (int i = 0; i < contents.size(); i++) {
      JSONArray templates = new JSONArray();

      for (int j = 0; j < contents.get(i).getPackages().size(); j++) {
        JSONObject temp = new JSONObject();
        temp.setInt("id", contents.get(i).getPackages().get(j).id);
        temp.setString("raw-data", contents.get(i).getPackages().get(j).rawData);
        temp.setString("refined-data", contents.get(i).getPackages().get(j).refinedData);
        templates.append(temp);
      }

      JSONObject temp = new JSONObject();
      temp.setString("character", str(contents.get(i).getCharacter()));
      temp.setJSONArray("templates", templates);
      jsonContents.append(temp);
    }

    JSONObject setting = new JSONObject();
    setting.setInt("sizeX", this.sizeX);
    setting.setInt("sizeY", this.sizeY);
    setting.setInt("fps", this.fps);
    setting.setString("split-pattern", this.splitPattern);
    setting.setInt("minimum-stroke", 10);

    JSONObject json = new JSONObject();
    json.setString("version", this.version);
    json.setString("date", this.date);
    json.setJSONObject("setting", setting);
    json.setJSONArray("contents", jsonContents);

    String fullPath;
    if (this.isAbsolutePath) {
      fullPath = path + name;
    } else {
      fullPath = "data/" + path + name;
    }
    saveJSONObject(json, fullPath);
    println("Data template is successfully updated");
    println("Template location: " + (this.isAbsolutePath ? path + name : dataFile(path + name).getPath()));
  }

  public void printTemplateInfo() {
    println("");
    println("===== TEMPLATE DATA SUMMARY =====");
    println("* VERSION        : " + this.version);
    println("* DATE           : " + this.date);
    println("* WINDOW SIZE    : (" + this.sizeX + ", " + this.sizeY + ") [px]");
    println("* FPS            : " + this.fps + "[frame/sec]");
    println("* SPLIT PATTERN  : " + this.splitPattern);
    println("* MINIMUM STROKE : " + this.minStroke);
    println("* DATA: " + (contents.size() == 0 ? "<empty>" : ""));
    for (int i = 0; i < contents.size(); i++) {
      println("*   [" + contents.get(i).getCharacter() + "]");

      for (int j = 0; j < contents.get(i).getPackages().size(); j++) {
        println("*     ID      : " + contents.get(i).getPackages().get(j).id);
        println("*     RAW     : " + contents.get(i).getPackages().get(j).rawData);
        println("*     REFINED : " + contents.get(i).getPackages().get(j).refinedData);
      }
    }
  }
}
