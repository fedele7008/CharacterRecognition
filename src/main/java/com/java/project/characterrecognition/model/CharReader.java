package com.java.project.characterrecognition.model;

import java.util.Scanner;

public class CharReader {

    private static final int WIDTH = 800;
    private static final int HEIGHT = 800;
    private static Scanner scanner;

    public CharReader() {
        scanner = new Scanner(System.in);
    }

    public static void readData() {
        System.out.println("Enter your data: ");
        String data = scanner.nextLine();
    }

}
