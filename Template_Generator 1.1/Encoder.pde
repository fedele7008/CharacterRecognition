public static class Encoder {
  public static String encode(ArrayList<Coordinate> coor, String pattern) {
    String result = "";

    for (int i = 0; i < coor.size(); i++) {
      if (i > 0 && i != coor.size() - 1) result += pattern;
      if (coor.get(i) == null) continue;
      result += coor.get(i).getCoor();
    }
    
    println(result);

    return result;
  }
}
